<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\RentHistoryModel;
use App\Model\RentModel;
use App\Model\UserModel;
use Hyperf\Contract\ConfigInterface;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;

class RentPaymentService
{
    public const PAYMENT_METHOD_WALLET = 'wallet';

    /**
     * @var list<string>
     */
    private const H5_PAYMENT_METHODS = [
        'fpx',
        'tng',
        'grab',
        'visa',
    ];

    #[Inject]
    protected RentHistoryService $historyService;

    public function __construct(
        private ConfigInterface $config,
        private FiuuChannelService $fiuuChannelService,
    ) {
    }

    /**
     * @return array{order_id: string, payment_url: string, history_id: int}
     */
    public function createPayOrder(
        int $userId,
        int $rentId,
        string $paymentMethod,
        ?string $paymentChannel = null
    ): array
    {
        $paymentMethod = strtolower(trim($paymentMethod));
        if (! in_array($paymentMethod, self::H5_PAYMENT_METHODS, true)) {
            throw new AppException('Invalid payment method');
        }

        $this->assertFiuuConfigReady();

        return Db::transaction(function () use ($userId, $rentId, $paymentMethod, $paymentChannel) {
            [$history, $rent] = $this->findPendingPaymentContext($userId, $rentId);
            $baseAmount = $this->resolveBaseAmount($history, $rent);
            $totalAmount = $this->calculateTotalAmount((float) $baseAmount, $paymentMethod);
            $orderId = $this->buildOrderId((int) $history->id);
            $channel = $this->fiuuChannelService->resolve($paymentMethod, $paymentChannel);

            $history->order_id = $orderId;
            $history->payment_method = $paymentMethod;
            $history->amount = number_format($totalAmount, 2, '.', '');
            $history->txn_id = '';
            $history->channel = '';
            $history->save();

            return [
                'order_id' => $orderId,
                'payment_url' => $this->buildPayPageUrl($orderId, $channel),
                'history_id' => (int) $history->id,
            ];
        });
    }

    public function completePayByOrderId(
        string $orderId,
        string $txnId,
        string $amount,
        string $channel
    ): void {
        Db::transaction(function () use ($orderId, $txnId, $amount, $channel) {
            $history = RentHistoryModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $history) {
                throw new AppException('Rent payment order not found');
            }

            if ((int) $history->status === RentHistoryModel::STATUS_PAID) {
                return;
            }

            if ((int) $history->status !== RentHistoryModel::STATUS_PENDING) {
                throw new AppException('Rent payment order is not payable');
            }

            if ($this->formatAmount($history->amount) !== $this->formatAmount($amount)) {
                throw new AppException('Payment amount mismatch');
            }

            if ($txnId !== '') {
                $history->txn_id = $txnId;
            }
            if ($channel !== '') {
                $history->channel = $channel;
            }

            $history->status = RentHistoryModel::STATUS_PAID;
            $history->user_paid_at = date('Y-m-d H:i:s');
            $history->save();
        });
    }

    public function markPayFailed(string $orderId, string $txnId, string $channel): void
    {
        Db::transaction(function () use ($orderId, $txnId, $channel) {
            $history = RentHistoryModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $history) {
                throw new AppException('Rent payment order not found');
            }

            if ((int) $history->status === RentHistoryModel::STATUS_PAID) {
                return;
            }

            if ($txnId !== '') {
                $history->txn_id = $txnId;
            }
            if ($channel !== '') {
                $history->channel = $channel;
            }

            $history->save();
        });
    }

    /**
     * @return array<string, mixed>
     */
    public function payByWallet(int $userId, int $rentId, string $paymentMethod): array
    {
        $paymentMethod = strtolower(trim($paymentMethod));
        if ($paymentMethod !== self::PAYMENT_METHOD_WALLET) {
            throw new AppException('Invalid payment method');
        }

        return Db::transaction(function () use ($userId, $rentId, $paymentMethod) {
            [$history, $rent] = $this->findPendingPaymentContext($userId, $rentId);
            $amount = $this->resolveBaseAmount($history, $rent);

            $this->deductWalletBalance($userId, $amount);

            $history->status = RentHistoryModel::STATUS_PAID;
            $history->user_paid_at = date('Y-m-d H:i:s');
            $history->payment_method = $paymentMethod;
            if (bccomp((string) $history->amount, '0', 2) <= 0) {
                $history->amount = $amount;
            }
            $history->save();

            $history->load([
                'rent:id,amount,landlord_account_name,property_id,property_name',
                'rent.property:id,name,address',
            ]);

            return $this->historyService->formatAppListItem($history);
        });
    }

    /**
     * @return array{0: RentHistoryModel, 1: RentModel}
     */
    private function findPendingPaymentContext(int $userId, int $rentId): array
    {
        $rent = RentModel::query()
            ->where('id', $rentId)
            ->where('user_id', $userId)
            ->lockForUpdate()
            ->first();

        if (! $rent) {
            throw new AppException('Rent not found');
        }

        if ((int) $rent->status === RentModel::STATUS_TERMINATED) {
            throw new AppException('Rent has been terminated');
        }

        if ((int) $rent->status !== RentModel::STATUS_APPROVED) {
            throw new AppException('Rent is not approved for payment');
        }

        $historyQuery = RentHistoryModel::query()
            ->where('rent_id', $rentId)
            ->where('user_id', $userId);
        $this->historyService->applyPayablePendingScope($historyQuery);

        $history = $historyQuery
            ->orderBy('last_paid_date')
            ->lockForUpdate()
            ->first();

        if (! $history) {
            throw new AppException('No payment due');
        }

        $amount = $this->resolveBaseAmount($history, $rent);
        if (bccomp($amount, '0', 2) <= 0) {
            throw new AppException('Invalid payment amount');
        }

        return [$history, $rent];
    }

    private function deductWalletBalance(int $userId, string $amount): void
    {
        $user = UserModel::query()->lockForUpdate()->find($userId);
        if (! $user) {
            throw new AppException('User does not exist');
        }

        if ((int) $user->status !== 1) {
            throw new AppException('Account has been disabled');
        }

        if (bccomp((string) $user->balance, $amount, 2) < 0) {
            throw new AppException('Insufficient wallet balance');
        }

        $newBalance = bcsub((string) $user->balance, $amount, 2);
        if (bccomp($newBalance, '0', 2) < 0) {
            throw new AppException('Insufficient wallet balance');
        }

        $user->balance = $newBalance;
        $user->save();
    }

    private function resolveBaseAmount(RentHistoryModel $history, RentModel $rent): string
    {
        $rentAmount = number_format((float) $rent->amount, 2, '.', '');
        if (bccomp($rentAmount, '0', 2) > 0) {
            return $rentAmount;
        }

        $historyAmount = (string) ($history->amount ?? '0');
        if ($historyAmount !== '' && bccomp($historyAmount, '0', 2) > 0) {
            return number_format((float) $historyAmount, 2, '.', '');
        }

        return '0.00';
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

    private function buildOrderId(int $historyId): string
    {
        return 'TR' . $historyId;
    }

    private function formatAmount(mixed $value): string
    {
        return number_format((float) $value, 2, '.', '');
    }
}
