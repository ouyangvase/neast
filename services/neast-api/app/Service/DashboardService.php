<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\LandlordModel;
use App\Model\MerchantModel;
use App\Model\UserModel;
use Carbon\Carbon;
use Hyperf\Database\Query\Expression;
use Hyperf\Di\Annotation\Inject;

class DashboardService
{
    #[Inject]
    protected UserActiveService $userActiveService;

    public function stats(): array
    {
        $today = Carbon::today();
        $monthStart = Carbon::today()->startOfMonth();

        return [
            'totals' => [
                'users' => UserModel::query()->count(),
                'landlords' => LandlordModel::query()->count(),
                'merchants' => MerchantModel::query()->count(),
            ],
            'active_users' => $this->userActiveService->stats(),
            'new_users' => [
                'today' => UserModel::query()->whereDate('created_at', $today)->count(),
                'month' => UserModel::query()->where('created_at', '>=', $monthStart)->count(),
                'daily' => $this->countByDay('created_at', 30, false),
                'monthly' => $this->countByMonth('created_at', 12, false),
            ],
        ];
    }

    /**
     * @return array<int, array{date: string, count: int}>
     */
    private function countByDay(string $column, int $days, bool $requireNotNull): array
    {
        $start = Carbon::today()->subDays($days - 1)->startOfDay();

        $query = UserModel::query()
            ->where($column, '>=', $start);

        if ($requireNotNull) {
            $query->whereNotNull($column);
        }

        $counts = $query
            ->selectRaw("DATE(`{$column}`) as stat_date, COUNT(*) as aggregate_count")
            ->groupBy(new Expression("DATE(`{$column}`)"))
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
    private function countByMonth(string $column, int $months, bool $requireNotNull): array
    {
        $start = Carbon::today()->startOfMonth()->subMonths($months - 1);

        $query = UserModel::query()
            ->where($column, '>=', $start);

        if ($requireNotNull) {
            $query->whereNotNull($column);
        }

        $counts = $query
            ->selectRaw("DATE_FORMAT(`{$column}`, '%Y-%m') as stat_month, COUNT(*) as aggregate_count")
            ->groupBy(new Expression("DATE_FORMAT(`{$column}`, '%Y-%m')"))
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
