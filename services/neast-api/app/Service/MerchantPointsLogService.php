<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\GivePointsRecordModel;
use App\Model\MerchantModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class MerchantPointsLogService
{
    /**
     * 商家积分发放记录列表（t_give_points_record）
     */
    public function listByMerchant(int $merchantId, RequestInterface $request): array
    {
        $this->assertMerchantExists($merchantId);

        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $query = GivePointsRecordModel::query()
            ->with(['user:id,account,first_name,last_name'])
            ->where('merchant_id', $merchantId);

        $total = (clone $query)->count();

        $items = $query->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (GivePointsRecordModel $record) {
                $user = $record->user;

                return [
                    'id' => (int) $record->id,
                    'merchant_id' => (int) $record->merchant_id,
                    'user_id' => (int) $record->user_id,
                    'amount' => number_format((float) $record->amount, 2, '.', ''),
                    'points' => (int) $record->points,
                    'notes' => (string) $record->notes,
                    'receipt_number' => (string) $record->receipt_number,
                    'receipt_path' => (string) $record->receipt_path,
                    'user_account' => $user?->account ?? '',
                    'user_name' => trim(trim((string) ($user?->first_name ?? '')) . ' ' . trim((string) ($user?->last_name ?? ''))),
                    'created_at' => $record->created_at?->format('Y-m-d H:i:s') ?? '',
                    'updated_at' => $record->updated_at?->format('Y-m-d H:i:s') ?? '',
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

    private function assertMerchantExists(int $merchantId): void
    {
        if (! MerchantModel::query()->where('id', $merchantId)->exists()) {
            throw new AppException('Merchant not found');
        }
    }
}
