<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\LandlordModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class LandlordService
{
    /**
     * 房东列表（关键词/状态筛选、分页）
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $keyword = trim((string) $request->input('keyword', ''));
        $status = $request->input('status', null);

        $query = LandlordModel::query();

        if ($keyword !== '') {
            $query->where(function ($q) use ($keyword) {
                $q->where('name', 'like', "%{$keyword}%")
                    ->orWhere('first_name', 'like', "%{$keyword}%")
                    ->orWhere('last_name', 'like', "%{$keyword}%")
                    ->orWhere('phone', 'like', "%{$keyword}%")
                    ->orWhere('email', 'like', "%{$keyword}%");
            });
        }

        if ($status !== null && $status !== '') {
            $query->where('status', (int) $status);
        }

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (LandlordModel $landlord) => $landlord->toArray())
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 房东详情
     */
    public function detail(int $id): array
    {
        return $this->findOrFail($id)->toArray();
    }

    /**
     * 创建房东
     */
    public function create(array $params): array
    {
        $phone = $this->normalizePhone((string) ($params['phone'] ?? ''));
        $this->assertPhoneUnique($phone);

        $landlord = new LandlordModel();
        $this->fillLandlord($landlord, $params);
        $landlord->phone = $phone;
        $landlord->save();

        return $landlord->toArray();
    }

    /**
     * 更新房东
     */
    public function update(int $id, array $params): array
    {
        $landlord = $this->findOrFail($id);

        $phone = $this->normalizePhone((string) ($params['phone'] ?? ''));
        if ($phone !== (string) $landlord->phone) {
            $this->assertPhoneUnique($phone, $id);
        }

        $this->fillLandlord($landlord, $params);
        $landlord->phone = $phone;
        $landlord->save();

        return $landlord->toArray();
    }

    /**
     * 状态切换
     */
    public function toggleStatus(int $id, int $status): void
    {
        $landlord = $this->findOrFail($id);
        $landlord->status = $status === 1 ? 1 : 0;
        $landlord->save();
    }

    private function fillLandlord(LandlordModel $landlord, array $params): void
    {
        $firstName = trim((string) ($params['first_name'] ?? ''));
        $lastName = trim((string) ($params['last_name'] ?? ''));
        $landlord->first_name = $firstName;
        $landlord->last_name = $lastName;
        $landlord->name = trim($firstName . ' ' . $lastName);
        $landlord->email = trim((string) ($params['email'] ?? ''));
        $landlord->status = (int) ($params['status'] ?? 1);
    }

    private function normalizePhone(string $phone): string
    {
        $phone = preg_replace('/\D/', '', trim($phone)) ?? '';
        if ($phone === '') {
            throw new AppException('Phone number is required');
        }

        return $phone;
    }

    private function assertPhoneUnique(string $phone, ?int $excludeId = null): void
    {
        if ($phone === '') {
            throw new AppException('Phone number is required');
        }

        $query = LandlordModel::withTrashed()->where('phone', $phone);
        if ($excludeId !== null) {
            $query->where('id', '<>', $excludeId);
        }

        if ($query->exists()) {
            throw new AppException('Phone already exists');
        }
    }

    private function findOrFail(int $id): LandlordModel
    {
        $landlord = LandlordModel::query()->find($id);
        if (! $landlord) {
            throw new AppException('Landlord not found');
        }

        return $landlord;
    }
}
