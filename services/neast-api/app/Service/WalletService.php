<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\MerchantBillModel;
use App\Model\MerchantModel;
use App\Model\MerchantTopupModel;
use App\Model\RentHistoryModel;
use App\Model\UserModel;
use App\Model\UserTopupModel;
use Hyperf\Contract\ConfigInterface;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\Logger\LoggerFactory;
use Psr\Log\LoggerInterface;

class WalletService
{
    /**
     * @var list<string>
     */
    private const PAYMENT_METHODS = [
        UserTopupModel::PAYMENT_METHOD_FPX,
        UserTopupModel::PAYMENT_METHOD_TNG,
        UserTopupModel::PAYMENT_METHOD_GRAB,
        UserTopupModel::PAYMENT_METHOD_VISA,
    ];

    private LoggerInterface $logger;

    #[Inject]
    protected RentPaymentService $rentPaymentService;

    #[Inject]
    protected MerchantWalletService $merchantWalletService;

    #[Inject]
    protected SettlementService $settlementService;

    public function __construct(
        private ConfigInterface $config,
        private FiuuChannelService $fiuuChannelService,
        LoggerFactory $loggerFactory,
    ) {
        $this->logger = $loggerFactory->get('wallet');
    }

    /**
     * @return array{balance: string}
     */
    public function getBalance(int $userId): array
    {
        $user = $this->findUserOrFail($userId);

        return [
            'balance' => $this->formatAmount($user->balance),
        ];
    }

    /**
     * @return array{items: array<int, array<string, mixed>>, total: int, page: int, limit: int}
     */
    public function topupList(int $userId, int $page, int $limit, ?int $year = null, ?int $month = null): array
    {
        $this->findUserOrFail($userId);

        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 15;

        $query = UserTopupModel::query()
            ->where('user_id', $userId)
            ->where('status', UserTopupModel::STATUS_SUCCESS);

        if ($year !== null && $year > 0 && $month !== null && $month >= 1 && $month <= 12) {
            $start = sprintf('%04d-%02d-01', $year, $month);
            $end = date('Y-m-t', strtotime($start));
            $query->whereBetween('paid_at', [$start . ' 00:00:00', $end . ' 23:59:59']);
        }

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('paid_at')
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (UserTopupModel $topup) => $this->formatTopupItem($topup))
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
        int $userId,
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
        $this->findUserOrFail($userId);
        $totalAmount = $this->calculateTotalAmount($amount, $paymentMethod);
        $orderId = $this->generateOrderId($userId);

        return Db::transaction(function () use ($userId, $totalAmount, $paymentMethod, $orderId, $paymentChannel) {
            $topup = new UserTopupModel();
            $topup->user_id = $userId;
            $topup->amount = $totalAmount;
            $topup->payment_method = $paymentMethod;
            $topup->order_id = $orderId;
            $topup->status = UserTopupModel::STATUS_PENDING;
            $topup->save();

            $channel = $this->fiuuChannelService->resolve($paymentMethod, $paymentChannel);

            return [
                'order_id' => $orderId,
                'payment_url' => $this->buildPayPageUrl($orderId, $channel),
            ];
        });
    }

    /**
     * H5 payOrder：返回 MOLPay Seamless 表单字段（JSON，不包 success 壳）。
     *
     * @return array<string, mixed>
     */
    public function buildH5PayForm(string $orderId, string $channel): array
    {
        $orderId = trim($orderId);
        $channel = trim($channel);

        if ($orderId === '' || $channel === '') {
            throw new AppException('Invalid payment request');
        }

        $fiuuConfig = $this->assertFiuuConfigReady();
        $topup = UserTopupModel::query()
            ->where('order_id', $orderId)
            ->first();

        $rentHistory = null;
        $merchantTopup = null;
        $merchantBill = null;
        if (! $topup) {
            $rentHistory = RentHistoryModel::query()
                ->where('order_id', $orderId)
                ->where('status', RentHistoryModel::STATUS_PENDING)
                ->first();
        }

        if (! $topup && ! $rentHistory) {
            $merchantTopup = MerchantTopupModel::query()
                ->where('order_id', $orderId)
                ->first();
        }

        if (! $topup && ! $rentHistory && ! $merchantTopup) {
            $merchantBill = MerchantBillModel::query()
                ->where('order_id', $orderId)
                ->where('is_paid', 0)
                ->first();
        }

        if (! $topup && ! $rentHistory && ! $merchantTopup && ! $merchantBill) {
            throw new AppException('Payment order not found');
        }

        if ($topup && (int) $topup->status !== UserTopupModel::STATUS_PENDING) {
            throw new AppException('The order has been paid');
        }

        if ($merchantTopup && (int) $merchantTopup->status !== MerchantTopupModel::STATUS_PENDING) {
            throw new AppException('The order has been paid');
        }

        $merchantId = (string) $fiuuConfig['merchant_id'];
        $verifyKey = (string) $fiuuConfig['verify_key'];
        $currency = (string) ($fiuuConfig['currency'] ?? 'MYR');
        $country = (string) ($fiuuConfig['country'] ?? 'MY');
        $amount = $this->formatAmount(match (true) {
            (bool) $topup => $topup->amount,
            (bool) $rentHistory => $rentHistory->amount,
            (bool) $merchantTopup => $merchantTopup->amount,
            default => $merchantBill->pay_amount ?? $merchantBill->amount,
        });
        $h5BaseUrl = payment_h5_base_url();

        if ($topup) {
            $billDesc = 'Wallet Top-up';
            $user = UserModel::query()->find((int) $topup->user_id);
            if (! $user) {
                throw new AppException('User does not exist');
            }

            $billName = trim($user->first_name . ' ' . $user->last_name);
            if ($billName === '') {
                $billName = 'Neast User';
            }

            $billEmail = trim((string) $user->email);
            if ($billEmail === '') {
                $billEmail = 'noreply@neast.com';
            }

            $billMobile = (string) $user->account;
        } elseif ($rentHistory) {
            $billDesc = 'Rent Payment';
            $user = UserModel::query()->find((int) $rentHistory->user_id);
            if (! $user) {
                throw new AppException('User does not exist');
            }

            $billName = trim($user->first_name . ' ' . $user->last_name);
            if ($billName === '') {
                $billName = 'Neast User';
            }

            $billEmail = trim((string) $user->email);
            if ($billEmail === '') {
                $billEmail = 'noreply@neast.com';
            }

            $billMobile = (string) $user->account;
        } else {
            $billDesc = $merchantBill ? 'Settlement Payment' : 'Merchant Wallet Top-up';
            $merchantEntityId = $merchantBill
                ? (int) $merchantBill->merchant_id
                : (int) $merchantTopup->merchant_id;
            $merchant = MerchantModel::query()->find($merchantEntityId);
            if (! $merchant) {
                throw new AppException('Merchant does not exist');
            }

            $billName = trim((string) $merchant->name);
            if ($billName === '') {
                $billName = trim((string) $merchant->contact_name);
            }
            if ($billName === '') {
                $billName = 'Neast Merchant';
            }

            $billEmail = trim((string) $merchant->email);
            if ($billEmail === '') {
                $billEmail = trim((string) $merchant->contact_email);
            }
            if ($billEmail === '') {
                $billEmail = 'noreply@neast.com';
            }

            $billMobile = trim((string) $merchant->phone);
            if ($billMobile === '') {
                $billMobile = trim((string) $merchant->contact_phone);
            }
        }

        return [
            'status' => true,
            'mpsmerchantid' => $merchantId,
            'mpschannel' => $channel,
            'mpsamount' => $amount,
            'mpsorderid' => $orderId,
            'mpsbill_name' => $billName,
            'mpsbill_email' => $billEmail,
            'mpsbill_mobile' => $billMobile,
            'mpsbill_desc' => $billDesc,
            'mpscountry' => $country,
            'mpsvcode' => md5($amount . $merchantId . $orderId . $verifyKey . $currency),
            'mpscurrency' => $currency,
            'mpslangcode' => 'en',
            'mpstimer' => 3,
            'mpstokenstatus' => 1,
            'mpstimerbox' => '#counter',
            'mpscancelurl' => $h5BaseUrl . '/wallet/topup/notify',
            'mpsreturnurl' => $h5BaseUrl . '/wallet/topup/return',
            'mpsapiversion' => '3.28',
        ];
    }

    /**
     * H5 IPN 回调：验签并入账，返回 echo 文本。
     */
    public function handleH5Notify(array $params): string
    {
        $this->logger->info('Fiuu H5 notify: ' . json_encode($params, JSON_UNESCAPED_UNICODE));

        $status = $this->verifyH5PaymentParams($params);
        if ($status === 'invalid') {
            return 'error';
        }

        $orderId = trim((string) ($params['orderid'] ?? ''));
        $tranId = trim((string) ($params['tranID'] ?? ''));
        $amount = trim((string) ($params['amount'] ?? ''));
        $channel = trim((string) ($params['channel'] ?? ''));

        if ($orderId === '') {
            return 'error';
        }

        try {
            $isRentOrder = str_starts_with($orderId, 'TR');
            $isMerchantTopup = str_starts_with($orderId, 'TM');
            $isSettlementOrder = str_starts_with($orderId, 'TS');

            if ($status === '00') {
                if ($isRentOrder) {
                    $this->rentPaymentService->completePayByOrderId($orderId, $tranId, $amount, $channel);
                } elseif ($isMerchantTopup) {
                    $this->merchantWalletService->completeTopupByOrderId($orderId, $tranId, $amount, $channel);
                } elseif ($isSettlementOrder) {
                    $this->settlementService->completePayByOrderId($orderId, $tranId, $amount, $channel);
                } else {
                    $this->completeTopupByOrderId($orderId, $tranId, $amount, $channel);
                }

                return 'SUCCESS';
            }

            if ($status === '11') {
                if ($isRentOrder) {
                    $this->rentPaymentService->markPayFailed($orderId, $tranId, $channel);
                } elseif ($isMerchantTopup) {
                    $this->merchantWalletService->markTopupFailed($orderId, $tranId, $channel);
                } elseif ($isSettlementOrder) {
                    $this->settlementService->markPayFailed($orderId, $tranId, $channel);
                } else {
                    $this->markTopupFailed($orderId, $tranId, $channel);
                }
            }
        } catch (\Throwable $exception) {
            $this->logger->error('Fiuu H5 notify failed: ' . $exception->getMessage());

            return 'error';
        }

        return $status === '11' ? 'SUCCESS' : 'error';
    }

    /**
     * H5 Return 回调：验签后返回跳转状态 success|pending|failed。
     */
    public function resolveH5ReturnStatus(array $params): string
    {
        $this->logger->info('Fiuu H5 return: ' . json_encode($params, JSON_UNESCAPED_UNICODE));

        $status = $this->verifyH5PaymentParams($params);
        if ($status === 'invalid') {
            return 'failed';
        }

        if ($status === '00') {
            return 'success';
        }

        if ($status === '22') {
            return 'pending';
        }

        return 'failed';
    }

    /**
     * @param array<string, mixed> $payload
     * @return array{balance: string, topup: array<string, mixed>}
     */
    public function verifyTopup(int $userId, array $payload): array
    {
        $orderId = trim((string) ($payload['order_id'] ?? ''));
        $txnId = trim((string) ($payload['txn_id'] ?? ''));
        $amount = trim((string) ($payload['amount'] ?? ''));
        $statusCode = trim((string) ($payload['status_code'] ?? ''));
        $msgType = trim((string) ($payload['msg_type'] ?? ''));
        $channel = trim((string) ($payload['channel'] ?? ''));
        $chksum = trim((string) ($payload['chksum'] ?? ''));

        if ($orderId === '' || $txnId === '' || $amount === '' || $statusCode === '' || $msgType === '' || $chksum === '') {
            throw new AppException('Invalid payment result');
        }

        $fiuuConfig = $this->assertFiuuConfigReady();
        $merchantId = (string) $fiuuConfig['merchant_id'];
        $secretKey = (string) $fiuuConfig['secret_key'];

        $expectedChksum = md5($merchantId . $msgType . $txnId . $amount . $statusCode . $secretKey);
        if (! hash_equals(strtolower($expectedChksum), strtolower($chksum))) {
            throw new AppException('Payment verification failed');
        }

        return Db::transaction(function () use ($userId, $orderId, $txnId, $amount, $statusCode, $channel) {
            return $this->applyTopupStatus($userId, $orderId, $txnId, $amount, $statusCode, $channel);
        });
    }

    /**
     * @return array{balance: string, topup: array<string, mixed>}
     */
    private function completeTopupByOrderId(
        string $orderId,
        string $txnId,
        string $amount,
        string $channel
    ): array {
        return Db::transaction(function () use ($orderId, $txnId, $amount, $channel) {
            $topup = UserTopupModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $topup) {
                throw new AppException('Topup order not found');
            }

            return $this->applyTopupStatus(
                (int) $topup->user_id,
                $orderId,
                $txnId,
                $amount,
                '00',
                $channel,
                $topup
            );
        });
    }

    private function markTopupFailed(string $orderId, string $txnId, string $channel): void
    {
        Db::transaction(function () use ($orderId, $txnId, $channel) {
            $topup = UserTopupModel::query()
                ->where('order_id', $orderId)
                ->lockForUpdate()
                ->first();

            if (! $topup) {
                throw new AppException('Topup order not found');
            }

            if ((int) $topup->status === UserTopupModel::STATUS_SUCCESS) {
                return;
            }

            if ($txnId !== '') {
                $topup->txn_id = $txnId;
            }
            if ($channel !== '') {
                $topup->channel = $channel;
            }
            $topup->status = UserTopupModel::STATUS_FAILED;
            $topup->save();
        });
    }

    /**
     * @return array{balance: string, topup: array<string, mixed>}
     */
    private function applyTopupStatus(
        int $userId,
        string $orderId,
        string $txnId,
        string $amount,
        string $statusCode,
        string $channel,
        ?UserTopupModel $lockedTopup = null
    ): array {
        $topup = $lockedTopup ?? UserTopupModel::query()
            ->where('user_id', $userId)
            ->where('order_id', $orderId)
            ->lockForUpdate()
            ->first();

        if (! $topup) {
            throw new AppException('Topup order not found');
        }

        if ((int) $topup->status === UserTopupModel::STATUS_SUCCESS) {
            $user = UserModel::query()->find($userId);
            if (! $user) {
                throw new AppException('User does not exist');
            }

            return [
                'balance' => $this->formatAmount($user->balance),
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
            $user = UserModel::query()->lockForUpdate()->find($userId);
            if (! $user) {
                throw new AppException('User does not exist');
            }

            if ((int) $user->status !== 1) {
                throw new AppException('Account has been disabled');
            }

            $user->balance = bcadd((string) $user->balance, (string) $topup->amount, 2);
            $user->save();

            $topup->status = UserTopupModel::STATUS_SUCCESS;
            $topup->paid_at = date('Y-m-d H:i:s');
            $topup->save();

            return [
                'balance' => $this->formatAmount($user->balance),
                'topup' => $this->formatTopupItem($topup),
            ];
        }

        if ($statusCode === '11') {
            $topup->status = UserTopupModel::STATUS_FAILED;
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
     * @param array<string, mixed> $params
     */
    private function verifyH5PaymentParams(array $params): string
    {
        $fiuuConfig = $this->assertFiuuConfigReady();
        $secretKey = (string) $fiuuConfig['secret_key'];

        $tranId = (string) ($params['tranID'] ?? '');
        $orderId = (string) ($params['orderid'] ?? '');
        $status = (string) ($params['status'] ?? '');
        $domain = (string) ($params['domain'] ?? '');
        $amount = (string) ($params['amount'] ?? '');
        $currency = (string) ($params['currency'] ?? '');
        $appcode = (string) ($params['appcode'] ?? '');
        $paydate = (string) ($params['paydate'] ?? '');
        $skey = (string) ($params['skey'] ?? '');

        if ($orderId === '' || $skey === '') {
            return 'invalid';
        }

        $key0 = md5($tranId . $orderId . $status . $domain . $amount . $currency);
        $key1 = md5($paydate . $domain . $key0 . $appcode . $secretKey);

        if (! hash_equals(strtolower($key1), strtolower($skey))) {
            return 'invalid';
        }

        return $status;
    }

    /**
     * @return array<string, mixed>
     */
    private function formatTopupItem(UserTopupModel $topup): array
    {
        return [
            'id' => $topup->id,
            'user_id' => $topup->user_id,
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

    private function generateOrderId(int $userId): string
    {
        return sprintf('TU%d%s%s', $userId, date('YmdHis'), substr(md5(uniqid((string) mt_rand(), true)), 0, 8));
    }

    private function formatAmount(mixed $value): string
    {
        return number_format((float) $value, 2, '.', '');
    }

    private function findUserOrFail(int $userId): UserModel
    {
        $user = UserModel::query()->find($userId);
        if (! $user) {
            throw new AppException('User does not exist');
        }

        if ((int) $user->status !== 1) {
            throw new AppException('Account has been disabled');
        }

        return $user;
    }
}
