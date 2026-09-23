<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\LandlordModel;
use App\Model\LandlordPropertyModel;
use Hyperf\HttpServer\Contract\RequestInterface;

use function Hyperf\Support\env;

class LandlordPropertyService
{
    /**
     * 房东物业列表（Admin）
     */
    public function listByLandlord(int $landlordId, RequestInterface $request): array
    {
        $this->assertLandlordExists($landlordId);

        return $this->paginate(
            LandlordPropertyModel::query()->where('landlord_id', $landlordId),
            $request
        );
    }

    /**
     * 房东端：当前登录房东的物业列表
     */
    public function listForLandlord(int $landlordId, RequestInterface $request): array
    {
        $this->assertLandlordExists($landlordId);

        return $this->paginate(
            LandlordPropertyModel::query()->where('landlord_id', $landlordId),
            $request
        );
    }

    /**
     * 房东端：创建物业
     */
    public function create(int $landlordId, array $params): array
    {
        $this->assertLandlordExists($landlordId);

        $name = trim((string) ($params['name'] ?? ''));
        $address = trim((string) ($params['address'] ?? ''));
        $image = trim((string) ($params['image'] ?? ''));
        $file = trim((string) ($params['file'] ?? ''));

        if ($name === '' || $address === '' || $image === '' || $file === '') {
            throw new AppException('Invalid property data');
        }

        $property = new LandlordPropertyModel();
        $property->landlord_id = $landlordId;
        $property->sn = $this->generateUniqueSn();
        $property->name = $name;
        $property->address = $address;
        $property->image = $image;
        $property->file = $file;
        $property->save();

        return $this->formatProperty($property->toArray());
    }

    private function paginate($query, RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (LandlordPropertyModel $property) => $this->formatProperty($property->toArray()))
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    private function formatProperty(array $data): array
    {
        $data['image'] = $this->resolveFileUrl((string) ($data['image'] ?? ''));
        $data['file'] = $this->resolveFileUrl((string) ($data['file'] ?? ''));

        return $data;
    }

    private function resolveFileUrl(string $path): string
    {
        if ($path === '') {
            return '';
        }

        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return $path;
        }

        if (function_exists('file_url')) {
            return file_url($path);
        }

        $base = rtrim((string) env('APP_URL', ''), '/');

        return $base . ($path[0] === '/' ? $path : '/' . $path);
    }

    private function assertLandlordExists(int $landlordId): void
    {
        if (! LandlordModel::query()->where('id', $landlordId)->exists()) {
            throw new AppException('Landlord not found');
        }
    }

    private function generateUniqueSn(): string
    {
        for ($attempt = 0; $attempt < 5; ++$attempt) {
            $sn = 'LP' . strtoupper(bin2hex(random_bytes(8)));
            if (! LandlordPropertyModel::withTrashed()->where('sn', $sn)->exists()) {
                return $sn;
            }
        }

        throw new AppException('Failed to generate property serial number');
    }
}
