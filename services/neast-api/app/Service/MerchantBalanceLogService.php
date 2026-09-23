<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\MerchantBalanceLogModel;
use App\Model\MerchantModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class MerchantBalanceLogService
{
    /**
     * 商家余额流水列表
     */
    public function listByMerchant(int $merchantId, RequestInterface $request): array
    {
        $this->assertMerchantExists($merchantId);

        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $query = MerchantBalanceLogModel::query()
            ->where('merchant_id', $merchantId);

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (MerchantBalanceLogModel $log) => $log->toArray())
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
