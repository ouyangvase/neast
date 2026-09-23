<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\GivePointsRecordModel;
use App\Model\MerchantModel;
use App\Model\UserModel;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;

class GivePointsService
{
    #[Inject]
    protected UserPointsService $userPointsService;

    #[Inject]
    protected PointsLogService $pointsLogService;

    /**
     * 今日佣金 RM = 今日发放积分总和 / points_per_rm
     */
    public function todayCommission(int $merchantId): array
    {
        $today = date('Y-m-d');
        $pointsSum = (int) GivePointsRecordModel::query()
            ->where('merchant_id', $merchantId)
            ->whereDate('created_at', $today)
            ->sum('points');

        $merchant = MerchantModel::query()->find($merchantId);
        if (! $merchant) {
            throw new AppException('Merchant not found');
        }

        $pointsPerRm = (int) ($merchant->points_per_rm ?? 1);
        if ($pointsPerRm <= 0) {
            $pointsPerRm = 1;
        }

        $commissionRm = round($pointsSum / $pointsPerRm, 2);

        return [
            'points' => $pointsSum,
            'commission_rm' => number_format($commissionRm, 2, '.', ''),
        ];
    }

    /**
     * Give Points 页统计卡片
     *
     * @return array{
     *     customers_today: int,
     *     avg_spend: string,
     *     points_today: int,
     *     repeat_customers: int
     * }
     */
    public function stats(int $merchantId): array
    {
        $today = date('Y-m-d');
        $todayQuery = GivePointsRecordModel::query()
            ->where('merchant_id', $merchantId)
            ->whereDate('created_at', $today);

        $customersToday = (int) (clone $todayQuery)->distinct()->count('user_id');
        $pointsToday = (int) (clone $todayQuery)->sum('points');

        $allQuery = GivePointsRecordModel::query()->where('merchant_id', $merchantId);
        $recordCount = (int) (clone $allQuery)->count();
        $amountSum = (float) (clone $allQuery)->sum('amount');
        $avgSpend = $recordCount > 0 ? round($amountSum / $recordCount, 2) : 0.0;

        $repeatCustomers = (int) GivePointsRecordModel::query()
            ->where('merchant_id', $merchantId)
            ->select('user_id')
            ->groupBy('user_id')
            ->havingRaw('COUNT(*) > 1')
            ->get()
            ->count();

        return [
            'customers_today' => $customersToday,
            'avg_spend' => number_format($avgSpend, 2, '.', ''),
            'points_today' => $pointsToday,
            'repeat_customers' => $repeatCustomers,
        ];
    }

    /**
     * 通过用户 ID 查询客户账号（手机号）
     *
     * @return array<string, string>
     */
    public function customerByUserId(int $userId): array
    {
        if ($userId <= 0) {
            throw new AppException('Invalid user id');
        }

        $user = UserModel::query()->find($userId);
        if (! $user) {
            throw new AppException('Customer not found');
        }

        if ((int) $user->status !== 1) {
            throw new AppException('Customer account has been disabled');
        }

        return [
            'account' => (string) $user->account,
        ];
    }

    /**
     * 确认发放积分
     */
    public function confirm(int $merchantId, array $params): array
    {
        $requestMerchantId = (int) ($params['merchant_id'] ?? 0);
        if ($requestMerchantId !== $merchantId) {
            throw new AppException('Invalid merchant');
        }

        $user = $this->resolveUserByCustomer((string) ($params['customer'] ?? ''));
        if (! $user) {
            throw new AppException('Customer not found');
        }

        if ((int) $user->status !== 1) {
            throw new AppException('Customer account has been disabled');
        }

        $points = (int) ($params['points'] ?? 0);
        if ($points <= 0) {
            throw new AppException('Invalid points');
        }

        return Db::transaction(function () use ($merchantId, $params, $user, $points) {
            $record = new GivePointsRecordModel();
            $record->user_id = (int) $user->id;
            $record->amount = number_format((float) ($params['amount'] ?? 0), 2, '.', '');
            $record->points = $points;
            $record->merchant_id = $merchantId;
            $record->notes = trim((string) ($params['notes'] ?? ''));
            $record->receipt_number = trim((string) ($params['receipt_number'] ?? ''));
            $record->receipt_path = trim((string) ($params['receipt_path'] ?? ''));
            $record->save();

            $this->userPointsService->grant((int) $user->id, $points);

            $merchant = MerchantModel::query()->find($merchantId);
            $this->pointsLogService->log(
                (int) $user->id,
                $points,
                'Merchant Give Points',
                (string) ($merchant->name ?? '')
            );

            return [
                'id' => (int) $record->id,
                'user_id' => (int) $record->user_id,
                'success' => true,
            ];
        });
    }

    private function resolveUserByCustomer(string $customer): ?UserModel
    {
        $customer = trim($customer);
        if ($customer === '') {
            return null;
        }

        $user = UserModel::query()->where('account', $customer)->first();
        if ($user) {
            return $user;
        }

        $digits = preg_replace('/\D/', '', $customer) ?? '';
        if ($digits !== '' && $digits !== $customer) {
            return UserModel::query()->where('account', $digits)->first();
        }

        return null;
    }
}
