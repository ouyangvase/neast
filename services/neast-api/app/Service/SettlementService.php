<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\GivePointsRecordModel;
use App\Model\MerchantBillModel;
use App\Model\MerchantModel;
use App\Model\UserCouponModel;
use Hyperf\Contract\ConfigInterface;
use Hyperf\DbConnection\Db;

class SettlementService
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

    public function __construct(
        private ConfigInterface $config,
        private FiuuChannelService $fiuuChannelService,
    ) {
    }

    /**
     * @return array{
     *     id: int|null,
     *     bill_month: string,
     *     merchant_id: int,
     *     amount: string,
     *     points: int,
     *     is_paid: int,
     *     redeemed: int,
     *     show_pay_now: bool
     * }
     */
    public function overview(int $merchantId): array
    {
        $unpaidBill = MerchantBillModel::query()
            ->where('merchant_id', $merchantId)
            ->where('is_paid', 0)
            ->orderByDesc('bill_month')
            ->orderByDesc('id')
            ->first();

        if ($unpaidBill) {
            $showPayNow = bccomp((string) $unpaidBill->amount, '0', 2) > 0;

            return $this->formatBillOverview($unpaidBill, $showPayNow);
        }

        $latestBill = MerchantBillModel::query()
            ->where('merchant_id', $merchantId)
            ->orderByDesc('bill_month')
            ->orderByDesc('id')
            ->first();

        if ($latestBill) {
            return $this->formatBillOverview($latestBill, false);
        }

        return $this->formatFallbackOverview($merchantId);
    }

    /**
     * @return array{order_id: string, payment_url: string, bill_id: int}
     */
    public function createPayOrder(
        int $merchantId,
        int $billId,
        string $paymentMethod,
        ?string $paymentChannel = null
    ): array
    {
        $paymentMethod = strtolower(trim($paymentMethod));
        if (! in_array($paymentMethod, self::H5_PAYMENT_METHODS, true)) {
            throw new AppException('Invalid payment method');
        }

        $this->assertFiuuConfigReady();

        return Db::transaction(function () use ($merchantId, $billId, $paymentMethod, $paymentChannel) {
            $bill = $this->findPayableBillOrFail($merchantId, $billId);
            $baseAmount = number_format((float) $bill->amount, 2, '.', '');
            $payAmount = number_format(
                $this->calculateTotalAmount((float) $baseAmount, $paymentMethod),
                2,
                '.',
                ''
            );
            $orderId = $this->buildOrderId((int) $bill->id);
            $channel = $this->fiuuChannelService->resolve($paymentMethod, $paymentChannel);

            $bill->order_id = $orderId;
            $bill->pay_amount = $payAmount;
            $bill->txn_id = '';
            $bill->channel = '';
            $bill->save();

            return [
                'order_id' => $orderId,
                'payment_url' => $this->buildPayPageUrl($orderId, $channel),
                'bill_id' => (int) $bill->id,
            ];
        });
    }

    /**
     * @return array{
     *     id: int|null,
     *     bill_month: string,
     *     merchant_id: int,
     *     amount: string,
     *     points: int,
     *     is_paid: int,
     *     redeemed: int,
     *     show_pay_now: bool
     * }
     */
    public function payByWallet(int $merchantId, int $billId, string $paymentMethod): array
    {
        $paymentMethod = strtolower(trim($paymentMethod));
        if ($paymentMethod !== self::PAYMENT_METHOD_WALLET) {
            throw new AppException('Invalid payment method');
        }

        Db::transaction(function () use ($merchantId, $billId) {
            $bill = $this->findPayableBillOrFail($merchantId, $billId);
            $amount = number_format((float) $bill->amount, 2, '.', '');

            $this->deductWalletBalance($merchantId, $amount);

            $bill->payment_method = MerchantBillModel::PAYMENT_METHOD_WALLET;
            $bill->is_paid = 1;
            $bill->payment_date = date('Y-m-d');
            $bill->save();
        });

        return $this->overview($merchantId);
    }

    public function completePayByOrderId(
        string $orderId,
        string $txnId,
        string $amount,
        string $channel
    ): void {
        Db::transaction(function () use ($orderId, $txnId, $amount, $channel) {
            $bill = MerchantBillModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $bill) {
                throw new AppException('Settlement payment order not found');
            }

            if ((int) $bill->is_paid === 1) {
                return;
            }

            $expectedAmount = $bill->pay_amount ?? $bill->amount;
            if ($this->formatAmount($expectedAmount) !== $this->formatAmount($amount)) {
                throw new AppException('Payment amount mismatch');
            }

            if ($txnId !== '') {
                $bill->txn_id = $txnId;
            }
            if ($channel !== '') {
                $bill->channel = $channel;
            }

            $bill->payment_method = MerchantBillModel::PAYMENT_METHOD_ONLINE;
            $bill->is_paid = 1;
            $bill->payment_date = date('Y-m-d');
            $bill->save();
        });
    }

    public function markPayFailed(string $orderId, string $txnId, string $channel): void
    {
        Db::transaction(function () use ($orderId, $txnId, $channel) {
            $bill = MerchantBillModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $bill) {
                throw new AppException('Settlement payment order not found');
            }

            if ((int) $bill->is_paid === 1) {
                return;
            }

            if ($txnId !== '') {
                $bill->txn_id = $txnId;
            }
            if ($channel !== '') {
                $bill->channel = $channel;
            }

            $bill->save();
        });
    }

    private function findPayableBillOrFail(int $merchantId, int $billId): MerchantBillModel
    {
        $bill = MerchantBillModel::query()
            ->where('id', $billId)
            ->where('merchant_id', $merchantId)
            ->lockForUpdate()
            ->first();

        if (! $bill) {
            throw new AppException('Bill not found');
        }

        if ((int) $bill->is_paid !== 0) {
            throw new AppException('Bill has already been paid');
        }

        $amount = number_format((float) $bill->amount, 2, '.', '');
        if (bccomp($amount, '0', 2) <= 0) {
            throw new AppException('Invalid bill amount');
        }

        return $bill;
    }

    private function deductWalletBalance(int $merchantId, string $amount): void
    {
        $merchant = MerchantModel::query()->lockForUpdate()->find($merchantId);
        if (! $merchant) {
            throw new AppException('Merchant does not exist');
        }

        if ((int) $merchant->status !== 1) {
            throw new AppException('Merchant account has been disabled');
        }

        if (bccomp((string) $merchant->balance, $amount, 2) < 0) {
            throw new AppException('Insufficient wallet balance');
        }

        $newBalance = bcsub((string) $merchant->balance, $amount, 2);
        if (bccomp($newBalance, '0', 2) < 0) {
            throw new AppException('Insufficient wallet balance');
        }

        $merchant->balance = $newBalance;
        $merchant->save();
    }

    /**
     * @return array{
     *     id: int|null,
     *     bill_month: string,
     *     merchant_id: int,
     *     amount: string,
     *     points: int,
     *     is_paid: int,
     *     redeemed: int,
     *     show_pay_now: bool
     * }
     */
    private function formatBillOverview(MerchantBillModel $bill, bool $showPayNow): array
    {
        $merchantId = (int) $bill->merchant_id;
        $billMonth = (string) $bill->bill_month;

        return [
            'id' => (int) $bill->id,
            'bill_month' => $billMonth,
            'merchant_id' => $merchantId,
            'amount' => number_format((float) $bill->amount, 2, '.', ''),
            'points' => (int) $bill->points,
            'is_paid' => (int) $bill->is_paid,
            'redeemed' => $this->countRedeemedInMonth($merchantId, $billMonth),
            'show_pay_now' => $showPayNow,
        ];
    }

    /**
     * @return array{
     *     id: int|null,
     *     bill_month: string,
     *     merchant_id: int,
     *     amount: string,
     *     points: int,
     *     is_paid: int,
     *     redeemed: int,
     *     show_pay_now: bool
     * }
     */
    private function formatFallbackOverview(int $merchantId): array
    {
        $billMonth = date('Y-m');
        [$startDate, $endDate] = $this->monthDateRange($billMonth);

        $recordQuery = GivePointsRecordModel::query()
            ->where('merchant_id', $merchantId)
            ->whereDate('created_at', '>=', $startDate)
            ->whereDate('created_at', '<=', $endDate);

        $amount = (float) (clone $recordQuery)->sum('amount');
        $points = (int) (clone $recordQuery)->sum('points');

        return [
            'id' => null,
            'bill_month' => $billMonth,
            'merchant_id' => $merchantId,
            'amount' => number_format($amount, 2, '.', ''),
            'points' => $points,
            'is_paid' => 0,
            'redeemed' => $this->countRedeemedInMonth($merchantId, $billMonth),
            'show_pay_now' => false,
        ];
    }

    private function countRedeemedInMonth(int $merchantId, string $billMonth): int
    {
        [$startDate, $endDate] = $this->monthDateRange($billMonth);

        return (int) UserCouponModel::query()
            ->where('redeemed_merchant_id', $merchantId)
            ->whereDate('redeemed_at', '>=', $startDate)
            ->whereDate('redeemed_at', '<=', $endDate)
            ->count();
    }

    /**
     * @return array{0: string, 1: string}
     */
    private function monthDateRange(string $billMonth): array
    {
        $startDate = $billMonth . '-01';
        $endDate = date('Y-m-t', strtotime($startDate));

        return [$startDate, $endDate];
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

    private function buildOrderId(int $billId): string
    {
        return 'TS' . $billId;
    }

    private function formatAmount(mixed $value): string
    {
        return number_format((float) $value, 2, '.', '');
    }
}
