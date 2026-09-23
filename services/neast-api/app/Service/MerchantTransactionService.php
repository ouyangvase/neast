<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\GivePointsRecordModel;
use App\Model\UserCouponModel;

class MerchantTransactionService
{
    /**
     * @return array{items: array<int, array<string, mixed>>, total: int, page: int, limit: int}
     */
    public function pointsList(int $merchantId, int $year, int $page, int $limit): array
    {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 15;

        $query = GivePointsRecordModel::query()
            ->where('merchant_id', $merchantId)
            ->whereYear('created_at', $year);

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (GivePointsRecordModel $record) {
                $createdAt = $record->created_at;

                return [
                    'id' => (int) $record->id,
                    'amount' => number_format((float) $record->amount, 2, '.', ''),
                    'points' => (int) $record->points,
                    'created_at' => $createdAt ? date('Y-m-d H:i:s', strtotime((string) $createdAt)) : '',
                ];
            })
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * @return array{items: array<int, array<string, mixed>>, total: int, page: int, limit: int}
     */
    public function redeemedList(int $merchantId, int $year, int $page, int $limit): array
    {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 15;

        $query = UserCouponModel::query()
            ->where('redeemed_merchant_id', $merchantId)
            ->whereNotNull('redeemed_at')
            ->whereYear('redeemed_at', $year);

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (UserCouponModel $coupon) {
                $redeemedAt = $coupon->redeemed_at;

                return [
                    'id' => (int) $coupon->id,
                    'name' => (string) $coupon->name,
                    'redeemed_at' => $redeemedAt instanceof \DateTimeInterface
                        ? $redeemedAt->format('Y-m-d H:i:s')
                        : ($redeemedAt ? date('Y-m-d H:i:s', strtotime((string) $redeemedAt)) : ''),
                ];
            })
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }
}
