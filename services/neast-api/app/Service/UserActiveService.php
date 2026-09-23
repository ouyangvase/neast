<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\UserActiveModel;
use Carbon\Carbon;
use Hyperf\Database\Query\Expression;

class UserActiveService
{
    /**
     * 记录用户当日活跃（同一用户同一天仅写入一条）。
     */
    public function recordDailyActive(int $userId): void
    {
        if ($userId <= 0) {
            return;
        }

        $today = date('Y-m-d');
        $now = date('Y-m-d H:i:s');

        UserActiveModel::query()->insertOrIgnore([
            'user_id' => $userId,
            'active_date' => $today,
            'created_at' => $now,
            'updated_at' => $now,
        ]);
    }

    /**
     * 后台 Dashboard 活跃用户统计
     *
     * @return array{today: int, month: int, daily: array<int, array{date: string, count: int}>, monthly: array<int, array{month: string, count: int}>}
     */
    public function stats(): array
    {
        $today = Carbon::today();
        $monthStart = Carbon::today()->startOfMonth();

        return [
            'today' => UserActiveModel::query()
                ->where('active_date', $today->format('Y-m-d'))
                ->count(),
            'month' => (int) UserActiveModel::query()
                ->where('active_date', '>=', $monthStart->format('Y-m-d'))
                ->selectRaw('COUNT(DISTINCT user_id) as aggregate_count')
                ->value('aggregate_count'),
            'daily' => $this->countDailyActiveByDay(30),
            'monthly' => $this->countMonthlyActiveUsers(12),
        ];
    }

    /**
     * @return array<int, array{date: string, count: int}>
     */
    private function countDailyActiveByDay(int $days): array
    {
        $start = Carbon::today()->subDays($days - 1);

        $counts = UserActiveModel::query()
            ->where('active_date', '>=', $start->format('Y-m-d'))
            ->selectRaw('active_date as stat_date, COUNT(*) as aggregate_count')
            ->groupBy('active_date')
            ->pluck('aggregate_count', 'stat_date')
            ->map(fn ($count) => (int) $count)
            ->all();

        $result = [];
        for ($i = 0; $i < $days; ++$i) {
            $date = $start->copy()->addDays($i)->format('Y-m-d');
            $result[] = [
                'date' => $date,
                'count' => $counts[$date] ?? 0,
            ];
        }

        return $result;
    }

    /**
     * @return array<int, array{month: string, count: int}>
     */
    private function countMonthlyActiveUsers(int $months): array
    {
        $start = Carbon::today()->startOfMonth()->subMonths($months - 1);

        $counts = UserActiveModel::query()
            ->where('active_date', '>=', $start->format('Y-m-d'))
            ->selectRaw("DATE_FORMAT(active_date, '%Y-%m') as stat_month, COUNT(DISTINCT user_id) as aggregate_count")
            ->groupBy(new Expression("DATE_FORMAT(active_date, '%Y-%m')"))
            ->pluck('aggregate_count', 'stat_month')
            ->map(fn ($count) => (int) $count)
            ->all();

        $result = [];
        for ($i = 0; $i < $months; ++$i) {
            $month = $start->copy()->addMonths($i)->format('Y-m');
            $result[] = [
                'month' => $month,
                'count' => $counts[$month] ?? 0,
            ];
        }

        return $result;
    }
}
