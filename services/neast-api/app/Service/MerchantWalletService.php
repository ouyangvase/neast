<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\MerchantModel;
use App\Model\MerchantTopupModel;
use Hyperf\Contract\ConfigInterface;
use Hyperf\DbConnection\Db;

class MerchantWalletService
{
    /**
     * @var list<string>
     */
    private const PAYMENT_METHODS = [
        MerchantTopupModel::PAYMENT_METHOD_FPX,
        MerchantTopupModel::PAYMENT_METHOD_TNG,
        MerchantTopupModel::PAYMENT_METHOD_GRAB,
        MerchantTopupModel::PAYMENT_METHOD_VISA,
    ];

    public function __construct(
        private ConfigInterface $config,
        private FiuuChannelService $fiuuChannelService,
    ) {
    }

    /**
     * @return array{items: array<int, array<string, mixed>>, total: int, page: int, limit: int}
     */
    public function topupList(int $merchantId, int $page, int $limit): array
    {
        $this->findMerchantOrFail($merchantId);

        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 15;

        $query = MerchantTopupModel::query()
            ->where('merchant_id', $merchantId)
            ->where('status', MerchantTopupModel::STATUS_SUCCESS);
        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('paid_at')
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (MerchantTopupModel $topup) => $this->formatTopupItem($topup))
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * @return array{order_id: string, payment_url: string}
     */
    public function createTopupOrder(
        int $merchantId,
        float $amount,
        string $paymentMethod,
        ?string $paymentChannel = null
    ): array
    {
        if ($amount < 1.01) {
            throw new AppException('Amount must be at least 1.01');
        }

        $paymentMethod = trim($paymentMethod);
        if (! in_array($paymentMethod, self::PAYMENT_METHODS, true)) {
            throw new AppException('Invalid payment method');
        }

        $this->assertFiuuConfigReady();
        $this->findMerchantOrFail($merchantId);
        $totalAmount = $this->calculateTotalAmount($amount, $paymentMethod);
        $orderId = $this->generateOrderId($merchantId);

        return Db::transaction(function () use ($merchantId, $totalAmount, $paymentMethod, $orderId, $paymentChannel) {
            $topup = new MerchantTopupModel();
            $topup->merchant_id = $merchantId;
            $topup->amount = $totalAmount;
            $topup->payment_method = $paymentMethod;
            $topup->order_id = $orderId;
            $topup->status = MerchantTopupModel::STATUS_PENDING;
            $topup->save();

            $channel = $this->fiuuChannelService->resolve($paymentMethod, $paymentChannel);

            return [
                'order_id' => $orderId,
                'payment_url' => $this->buildPayPageUrl($orderId, $channel),
            ];
        });
    }

    /**
     * @return array{balance: string, topup: array<string, mixed>}
     */
    public function completeTopupByOrderId(
        string $orderId,
        string $txnId,
        string $amount,
        string $channel
    ): array {
        return Db::transaction(function () use ($orderId, $txnId, $amount, $channel) {
            $topup = MerchantTopupModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $topup) {
                throw new AppException('Topup order not found');
            }

            return $this->applyTopupStatus(
                (int) $topup->merchant_id,
                $orderId,
                $txnId,
                $amount,
                '00',
                $channel,
                $topup
            );
        });
    }

    public function markTopupFailed(string $orderId, string $txnId, string $channel): void
    {
        Db::transaction(function () use ($orderId, $txnId, $channel) {
            $topup = MerchantTopupModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $topup) {
                throw new AppException('Topup order not found');
            }

            if ((int) $topup->status === MerchantTopupModel::STATUS_SUCCESS) {
                return;
            }

            if ($txnId !== '') {
                $topup->txn_id = $txnId;
            }
            if ($channel !== '') {
                $topup->channel = $channel;
            }
            $topup->status = MerchantTopupModel::STATUS_FAILED;
            $topup->save();
        });
    }

    /**
     * @return array{balance: string, topup: array<string, mixed>}
     */
    private function applyTopupStatus(
        int $merchantId,
        string $orderId,
        string $txnId,
        string $amount,
        string $statusCode,
        string $channel,
        ?MerchantTopupModel $lockedTopup = null
    ): array {
        $topup = $lockedTopup ?? MerchantTopupModel::query()
            ->where('merchant_id', $merchantId)
            ->where('order_id', $orderId)
            ->lockForUpdate()
            ->first();

        if (! $topup) {
            throw new AppException('Topup order not found');
        }

        if ((int) $topup->status === MerchantTopupModel::STATUS_SUCCESS) {
            $merchant = MerchantModel::query()->find($merchantId);
            if (! $merchant) {
                throw new AppException('Merchant does not exist');
            }

            return [
                'balance' => $this->formatAmount($merchant->balance),
                'topup' => $this->formatTopupItem($topup),
            ];
        }

        if ($this->formatAmount($topup->amount) !== $this->formatAmount($amount)) {
            throw new AppException('Payment amount mismatch');
        }

        if ($txnId !== '') {
            $topup->txn_id = $txnId;
        }
        if ($channel !== '') {
            $topup->channel = $channel;
        }

        if ($statusCode === '00') {
            $merchant = MerchantModel::query()->lockForUpdate()->find($merchantId);
            if (! $merchant) {
                throw new AppException('Merchant does not exist');
            }

            if ((int) $merchant->status !== 1) {
                throw new AppException('Merchant account has been disabled');
            }

            $merchant->balance = bcadd((string) $merchant->balance, (string) $topup->amount, 2);
            $merchant->save();

            $topup->status = MerchantTopupModel::STATUS_SUCCESS;
            $topup->paid_at = date('Y-m-d H:i:s');
            $topup->save();

            return [
                'balance' => $this->formatAmount($merchant->balance),
                'topup' => $this->formatTopupItem($topup),
            ];
        }

        if ($statusCode === '11') {
            $topup->status = MerchantTopupModel::STATUS_FAILED;
            $topup->save();

            throw new AppException('Payment failed');
        }

        if ($statusCode === '22') {
            $topup->save();

            throw new AppException('Payment is pending');
        }

        throw new AppException('Unknown payment status');
    }

    /**
     * @return array<string, mixed>
     */
    public function formatTopupItem(MerchantTopupModel $topup): array
    {
        return [
            'id' => $topup->id,
            'merchant_id' => $topup->merchant_id,
            'amount' => $this->formatAmount($topup->amount),
            'payment_method' => $topup->payment_method,
            'order_id' => $topup->order_id,
            'status' => (int) $topup->status,
            'txn_id' => $topup->txn_id,
            'channel' => $topup->channel,
            'paid_at' => $topup->paid_at?->format('Y-m-d H:i:s') ?? '',
            'created_at' => $topup->created_at?->format('Y-m-d H:i:s') ?? '',
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function assertFiuuConfigReady(): array
    {
        /** @var array<string, mixed> $fiuuConfig */
        $fiuuConfig = $this->config->get('fiuu', []);
        $required = ['merchant_id', 'verify_key', 'secret_key'];

        foreach ($required as $key) {
            if (trim((string) ($fiuuConfig[$key] ?? '')) === '') {
                throw new AppException('Payment gateway is not configured');
            }
        }

        return $fiuuConfig;
    }

    private function buildPayPageUrl(string $orderId, string $channel): string
    {
        $baseUrl = payment_h5_base_url();
        if ($baseUrl === '') {
            throw new AppException('Payment H5 base URL is not configured');
        }

        $query = http_build_query([
            'code' => $channel,
            'order_sn' => $orderId,
        ]);

        return $baseUrl . '/pay.html?' . $query;
    }

    private function calculateTotalAmount(float $amount, string $paymentMethod): float
    {
        /** @var array<string, float|int> $fees */
        $fees = $this->config->get('payment.processing_fees', []);
        $feePercent = (float) ($fees[$paymentMethod] ?? 0);

        return round($amount * (1 + $feePercent / 100), 2);
    }

    private function generateOrderId(int $merchantId): string
    {
        return sprintf('TM%d%s%s', $merchantId, date('YmdHis'), substr(md5(uniqid((string) mt_rand(), true)), 0, 8));
    }

    private function formatAmount(mixed $value): string
    {
        return number_format((float) $value, 2, '.', '');
    }

    private function findMerchantOrFail(int $merchantId): MerchantModel
    {
        $merchant = MerchantModel::query()->find($merchantId);
        if (! $merchant) {
            throw new AppException('Merchant does not exist');
        }

        if ((int) $merchant->status !== 1) {
            throw new AppException('Merchant account has been disabled');
        }

        return $merchant;
    }
}
