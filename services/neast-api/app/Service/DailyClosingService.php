<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\GivePointsRecordModel;
use App\Model\UserCouponModel;
use Hyperf\Di\Annotation\Inject;

class DailyClosingService
{
    #[Inject]
    protected GivePointsService $givePointsService;

    /**
     * @return array{redeemed: int, points: int, customers: int, commission_rm: string}
     */
    public function summary(int $merchantId): array
    {
        $today = date('Y-m-d');

        $redeemed = (int) UserCouponModel::query()
            ->where('redeemed_merchant_id', $merchantId)
            ->whereDate('redeemed_at', $today)
            ->count();

        $givePointsQuery = GivePointsRecordModel::query()
            ->where('merchant_id', $merchantId)
            ->whereDate('created_at', $today);

        $points = (int) (clone $givePointsQuery)->sum('points');
        $customers = (int) (clone $givePointsQuery)->count();

        $commission = $this->givePointsService->todayCommission($merchantId);

        return [
            'redeemed' => $redeemed,
            'points' => $points,
            'customers' => $customers,
            'commission_rm' => (string) ($commission['commission_rm'] ?? '0.00'),
        ];
    }

    /**
     * @return array{items: array<int, array<string, mixed>>, total: int, page: int, limit: int}
     */
    public function transactions(int $merchantId, int $page, int $limit): array
    {
        $today = date('Y-m-d');
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 20;

        $query = GivePointsRecordModel::query()
            ->where('merchant_id', $merchantId)
            ->whereDate('created_at', $today);

        $total = (clone $query)->count();

        $items = $query
            ->with(['user:id,first_name,last_name'])
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (GivePointsRecordModel $record) => $this->formatTransactionItem($record))
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * @return array{id: int, time: string, user_name: string, points: int, amount: string}
     */
    private function formatTransactionItem(GivePointsRecordModel $record): array
    {
        $user = $record->user;
        $userName = trim(trim((string) ($user?->first_name ?? '')) . ' ' . trim((string) ($user?->last_name ?? '')));

        $createdAt = $record->created_at;
        $time = $createdAt ? date('H:i', strtotime((string) $createdAt)) : '';

        return [
            'id' => (int) $record->id,
            'time' => $time,
            'user_name' => $userName,
            'points' => (int) $record->points,
            'amount' => number_format((float) $record->amount, 2, '.', ''),
        ];
    }
}
