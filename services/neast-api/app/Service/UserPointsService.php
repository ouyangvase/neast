<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\UserPointsModel;
use Carbon\Carbon;

class UserPointsService
{
    /** 商家发放积分默认有效期（天） */
    public const GRANT_VALID_DAYS = 30;

    /**
     * 写入一笔用户积分（发放）
     */
    public function grant(int $userId, int $points, ?Carbon $grantedAt = null): UserPointsModel
    {
        if ($userId <= 0) {
            throw new AppException('Invalid user');
        }

        if ($points <= 0) {
            throw new AppException('Invalid points');
        }

        $grantedAt ??= Carbon::now();
        $expiredDate = $grantedAt->copy()->addDays(self::GRANT_VALID_DAYS)->toDateString();

        $record = new UserPointsModel();
        $record->user_id = $userId;
        $record->points = $points;
        $record->expired_date = $expiredDate;
        $record->save();

        return $record;
    }

    /**
     * 用户未过期积分总和
     */
    public function availableBalance(int $userId): int
    {
        $today = Carbon::today()->toDateString();

        return (int) UserPointsModel::query()
            ->where('user_id', $userId)
            ->where('expired_date', '>=', $today)
            ->sum('points');
    }

    /**
     * 批量获取用户未过期积分总和
     *
     * @param array<int, int> $userIds
     * @return array<int, int> user_id => balance
     */
    public function availableBalancesForUsers(array $userIds): array
    {
        $userIds = array_values(array_unique(array_filter(
            array_map(static fn ($id) => (int) $id, $userIds),
            static fn (int $id) => $id > 0
        )));

        if ($userIds === []) {
            return [];
        }

        $today = Carbon::today()->toDateString();

        $rows = UserPointsModel::query()
            ->selectRaw('user_id, COALESCE(SUM(points), 0) as balance')
            ->whereIn('user_id', $userIds)
            ->where('expired_date', '>=', $today)
            ->groupBy('user_id')
            ->get();

        $balances = array_fill_keys($userIds, 0);
        foreach ($rows as $row) {
            $balances[(int) $row->user_id] = (int) $row->balance;
        }

        return $balances;
    }

    /**
     * 最近一批即将过期积分的结构化数据
     *
     * @return array{points: int, expired_date: string}|null
     */
    public function expiringSummary(int $userId): ?array
    {
        $today = Carbon::today()->toDateString();

        $nearestExpiry = UserPointsModel::query()
            ->where('user_id', $userId)
            ->where('expired_date', '>=', $today)
            ->where('points', '>', 0)
            ->orderBy('expired_date')
            ->value('expired_date');

        if ($nearestExpiry === null || $nearestExpiry === '') {
            return null;
        }

        $points = (int) UserPointsModel::query()
            ->where('user_id', $userId)
            ->where('expired_date', $nearestExpiry)
            ->where('points', '>', 0)
            ->sum('points');

        if ($points <= 0) {
            return null;
        }

        return [
            'points' => $points,
            'expired_date' => Carbon::parse((string) $nearestExpiry)->format('d M Y'),
        ];
    }

    /**
     * 最近一批即将过期积分的展示文案
     */
    public function expiringText(int $userId): string
    {
        $summary = $this->expiringSummary($userId);
        if ($summary === null) {
            return '';
        }

        return $summary['points'] . '  points expiring on ' . $summary['expired_date'];
    }

    /**
     * 扣减用户积分（先过期先扣，需在事务内调用）
     */
    public function deduct(int $userId, int $points): void
    {
        if ($userId <= 0) {
            throw new AppException('Invalid user');
        }

        if ($points <= 0) {
            return;
        }

        $today = Carbon::today()->toDateString();

        $records = UserPointsModel::query()
            ->where('user_id', $userId)
            ->where('expired_date', '>=', $today)
            ->where('points', '>', 0)
            ->orderBy('expired_date')
            ->orderBy('id')
            ->lockForUpdate()
            ->get();

        $available = (int) $records->sum('points');
        if ($available < $points) {
            throw new AppException('Insufficient points');
        }

        $remaining = $points;
        foreach ($records as $record) {
            if ($remaining <= 0) {
                break;
            }

            $current = (int) $record->points;
            if ($current <= 0) {
                continue;
            }

            $deduct = min($remaining, $current);
            $left = $current - $deduct;

            if ($left <= 0) {
                $record->delete();
            } else {
                $record->points = $left;
                $record->save();
            }

            $remaining -= $deduct;
        }

        if ($remaining > 0) {
            throw new AppException('Insufficient points');
        }
    }
}
