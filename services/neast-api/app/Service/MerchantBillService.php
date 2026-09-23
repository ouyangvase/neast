<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\MerchantBillModel;
use App\Model\MerchantModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class MerchantBillService
{
    /**
     * 账单聚合列表（商家多选、月份范围）
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $merchantIds = $this->normalizeMerchantIds($request->input('merchant_ids', []));
        $startMonth = $this->normalizeMonth($request->input('start_month', ''));
        $endMonth = $this->normalizeMonth($request->input('end_month', ''));

        $query = MerchantBillModel::query()
            ->with(['merchant:id,name']);

        if ($merchantIds !== []) {
            $query->whereIn('merchant_id', $merchantIds);
        }

        if ($startMonth !== '') {
            $query->where('bill_month', '>=', $startMonth);
        }

        if ($endMonth !== '') {
            $query->where('bill_month', '<=', $endMonth);
        }

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('bill_month')
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (MerchantBillModel $bill) {
                return $this->formatListItem($bill);
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
     * 商家账单列表
     */
    public function listByMerchant(int $merchantId, RequestInterface $request): array
    {
        $this->assertMerchantExists($merchantId);

        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $query = MerchantBillModel::query()
            ->where('merchant_id', $merchantId);

        $total = (clone $query)->count();

        $items = $query->orderBy('bill_month', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (MerchantBillModel $bill) => $bill->toArray())
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatListItem(MerchantBillModel $bill): array
    {
        $data = $bill->toArray();
        unset($data['merchant']);
        $data['merchant_name'] = $bill->merchant?->name ?? '';

        return $data;
    }

    private function assertMerchantExists(int $merchantId): void
    {
        if (! MerchantModel::query()->where('id', $merchantId)->exists()) {
            throw new AppException('Merchant not found');
        }
    }

    /**
     * @return int[]
     */
    private function normalizeMerchantIds(mixed $merchantIds): array
    {
        if (! is_array($merchantIds)) {
            return [];
        }

        return array_values(array_unique(array_filter(array_map(
            fn ($id) => (int) $id,
            $merchantIds
        ), fn ($id) => $id > 0)));
    }

    private function normalizeMonth(mixed $value): string
    {
        $month = trim((string) $value);
        if ($month === '') {
            return '';
        }

        if (! preg_match('/^\d{4}-\d{2}$/', $month)) {
            throw new AppException('Invalid month format');
        }

        return $month;
    }
}
