<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Job\NewMerchantNearbyBroadcastJob;
use App\Model\MerchantCategoryModel;
use App\Model\MerchantModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class MerchantService
{
    /**
     * 附近商家半径（km），接口写死。
     */
    public const NEARBY_RADIUS_KM = 20.0;

    /**
     * 商家列表（关键词/状态筛选、分页）
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $keyword = trim((string) $request->input('keyword', ''));
        $status = $request->input('status', null);

        $query = MerchantModel::query()->with(['category:id,name']);

        if ($keyword !== '') {
            $query->where(function ($q) use ($keyword) {
                $q->where('name', 'like', "%{$keyword}%")
                    ->orWhere('contact_name', 'like', "%{$keyword}%")
                    ->orWhere('contact_phone', 'like', "%{$keyword}%")
                    ->orWhere('phone', 'like', "%{$keyword}%");
            });
        }

        if ($status !== null && $status !== '') {
            $query->where('status', (int) $status);
        }

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->map(function (MerchantModel $merchant) {
                $data = $merchant->toArray();
                $data['category_name'] = $merchant->category?->name ?? '';
                unset($data['category']);

                return $data;
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
     * App 端商家分类列表
     */
    public function appCategories(): array
    {
        $items = MerchantCategoryModel::query()
            ->orderBy('id', 'asc')
            ->get(['id', 'name'])
            ->map(fn (MerchantCategoryModel $category) => [
                'id' => $category->id,
                'name' => $category->name,
            ])
            ->all();

        return ['items' => $items];
    }

    /**
     * App 端商家列表（按距离排序、分页）
     */
    public function appList(float $latitude, float $longitude, int $page, int $limit, ?int $categoryId = null): array
    {
        $merchants = $this->appActiveMerchantQuery($categoryId)
            ->get(['id', 'name', 'address', 'image', 'latitude', 'longitude', 'category_id']);

        $items = $this->mapMerchantsWithDistance($merchants, $latitude, $longitude);

        return $this->paginateSortedItems($items, $page, $limit);
    }

    /**
     * App 端推荐商家列表（按距离排序、分页）
     */
    public function appRecommended(float $latitude, float $longitude, int $page, int $limit): array
    {
        $merchants = MerchantModel::query()
            ->where('status', 1)
            ->where('is_recommended', 1)
            ->get(['id', 'name', 'address', 'image', 'latitude', 'longitude']);

        $items = $this->mapMerchantsWithDistance($merchants, $latitude, $longitude);

        return $this->paginateSortedItems($items, $page, $limit);
    }

    /**
     * App 端附近商家列表（有坐标、按距离排序、分页，不限半径）
     */
    public function appNearbyList(float $latitude, float $longitude, int $page, int $limit, ?int $categoryId = null): array
    {
        $merchants = $this->appActiveMerchantQuery($categoryId)
            ->whereNotNull('latitude')
            ->whereNotNull('longitude')
            ->get(['id', 'name', 'address', 'image', 'latitude', 'longitude', 'category_id']);

        $items = $this->mapMerchantsWithDistance($merchants, $latitude, $longitude);

        return $this->paginateSortedItems($items, $page, $limit);
    }

    /**
     * App 端附近商家（半径 20km 内，按距离升序，不分页）
     */
    public function appNearby(float $latitude, float $longitude, ?int $categoryId = null): array
    {
        $merchants = $this->appActiveMerchantQuery($categoryId)
            ->whereNotNull('latitude')
            ->whereNotNull('longitude')
            ->get(['id', 'name', 'image', 'latitude', 'longitude', 'category_id']);

        $items = $merchants->map(function (MerchantModel $merchant) use ($latitude, $longitude) {
            $distance = $this->haversineKm(
                $latitude,
                $longitude,
                (float) $merchant->latitude,
                (float) $merchant->longitude
            );

            return [
                'id' => $merchant->id,
                'name' => $merchant->name,
                'image' => env('APP_URL') . $merchant->image,
                'latitude' => (float) $merchant->latitude,
                'longitude' => (float) $merchant->longitude,
                'category_id' => $merchant->category_id,
                'distance' => $distance,
            ];
        })
            ->filter(fn (array $item) => $item['distance'] <= self::NEARBY_RADIUS_KM)
            ->sortBy('distance')
            ->values()
            ->all();

        return [
            'items' => $items,
            'radius' => self::NEARBY_RADIUS_KM,
        ];
    }

    /**
     * 商家详情
     */
    public function detail(int $id): array
    {
        return $this->findOrFail($id)->toArray();
    }

    /**
     * App 端商家详情（仅返回展示字段，可选计算距离）
     */
    public function appDetail(int $id, ?float $latitude = null, ?float $longitude = null): array
    {
        $merchant = MerchantModel::query()
            ->where('id', $id)
            ->where('status', 1)
            ->first(['id', 'name', 'address', 'image', 'latitude', 'longitude']);

        if (! $merchant) {
            throw new AppException('Merchant not found');
        }

        $distance = null;
        if ($latitude !== null && $longitude !== null
            && $merchant->latitude !== null && $merchant->longitude !== null
            && $merchant->latitude !== '' && $merchant->longitude !== '') {
            $distance = $this->haversineKm(
                $latitude,
                $longitude,
                (float) $merchant->latitude,
                (float) $merchant->longitude
            );
        }

        $lat = $merchant->latitude !== null && $merchant->latitude !== ''
            ? (float) $merchant->latitude
            : null;
        $lng = $merchant->longitude !== null && $merchant->longitude !== ''
            ? (float) $merchant->longitude
            : null;

        return [
            'id' => $merchant->id,
            'name' => $merchant->name,
            'address' => $merchant->address,
            'image' => env('APP_URL') . $merchant->image,
            'latitude' => $lat,
            'longitude' => $lng,
            'distance' => $distance,
            'nearest_merchant' => $this->findNearestMerchant($id, $lat, $lng, $latitude, $longitude),
        ];
    }

    /**
     * 查找距当前商家最近的另一家启用商家（基于商家经纬度）。
     * 返回的 distance 为用户当前位置到该附近商家的距离。
     */
    private function findNearestMerchant(
        int $excludeId,
        ?float $merchantLat,
        ?float $merchantLng,
        ?float $userLat = null,
        ?float $userLng = null
    ): ?array {
        if ($merchantLat === null || $merchantLng === null) {
            return null;
        }

        $merchants = MerchantModel::query()
            ->where('status', 1)
            ->where('id', '!=', $excludeId)
            ->whereNotNull('latitude')
            ->whereNotNull('longitude')
            ->get(['id', 'name', 'address', 'image', 'latitude', 'longitude']);

        $nearest = null;
        $minDistance = null;

        foreach ($merchants as $candidate) {
            if ($candidate->latitude === null || $candidate->longitude === null
                || $candidate->latitude === '' || $candidate->longitude === '') {
                continue;
            }

            $distance = $this->haversineKm(
                $merchantLat,
                $merchantLng,
                (float) $candidate->latitude,
                (float) $candidate->longitude
            );

            if ($minDistance === null || $distance < $minDistance) {
                $minDistance = $distance;
                $nearest = $candidate;
            }
        }

        if ($nearest === null) {
            return null;
        }

        $displayDistance = null;
        if ($userLat !== null && $userLng !== null) {
            $displayDistance = $this->haversineKm(
                $userLat,
                $userLng,
                (float) $nearest->latitude,
                (float) $nearest->longitude
            );
        }

        return [
            'id' => $nearest->id,
            'name' => $nearest->name,
            'address' => $nearest->address,
            'image' => env('APP_URL') . $nearest->image,
            'latitude' => (float) $nearest->latitude,
            'longitude' => (float) $nearest->longitude,
            'distance' => $displayDistance,
        ];
    }

    /**
     * 创建商家
     */
    public function create(array $params): array
    {
        $email = trim((string) ($params['email'] ?? ''));
        $this->assertEmailUnique($email);

        $password = trim((string) ($params['password'] ?? ''));
        if ($password === '') {
            throw new AppException('Password is required');
        }

        $merchant = new MerchantModel();
        $this->fillMerchant($merchant, $params);
        $merchant->password = password_hash($password, PASSWORD_DEFAULT);
        $merchant->save();

        $this->dispatchNewMerchantNearbyNotify($merchant);

        return $merchant->toArray();
    }

    /**
     * 更新商家
     */
    public function update(int $id, array $params): array
    {
        $merchant = $this->findOrFail($id);

        $email = trim((string) ($params['email'] ?? ''));
        if ($email !== $merchant->email) {
            $this->assertEmailUnique($email, $id);
        }

        $this->fillMerchant($merchant, $params);

        $password = trim((string) ($params['password'] ?? ''));
        if ($password !== '') {
            $merchant->password = password_hash($password, PASSWORD_DEFAULT);
        }

        $merchant->save();

        return $merchant->toArray();
    }

    /**
     * 删除商家（软删除）
     */
    public function delete(int $id): void
    {
        $merchant = $this->findOrFail($id);
        $merchant->delete();
    }

    /**
     * 状态切换
     */
    public function toggleStatus(int $id, int $status): void
    {
        $merchant = $this->findOrFail($id);
        $merchant->status = $status === 1 ? 1 : 0;
        $merchant->save();
    }

    /**
     * 推荐状态切换
     */
    public function toggleRecommended(int $id, int $isRecommended): void
    {
        $merchant = $this->findOrFail($id);
        $merchant->is_recommended = $isRecommended === 1 ? 1 : 0;
        $merchant->save();
    }

    /**
     * 商家下拉（启用）
     */
    public function options(): array
    {
        return MerchantModel::query()
            ->where('status', 1)
            ->orderBy('id', 'asc')
            ->get(['id', 'name'])
            ->toArray();
    }

    private function fillMerchant(MerchantModel $merchant, array $params): void
    {
        $merchant->latitude = $this->nullableDecimal($params['latitude'] ?? null);
        $merchant->longitude = $this->nullableDecimal($params['longitude'] ?? null);
        $merchant->name = trim((string) ($params['name'] ?? ''));
        $merchant->category_id = $this->resolveCategoryId($params['category_id'] ?? null);
        $merchant->address = trim((string) ($params['address'] ?? ''));
        $merchant->image = trim((string) ($params['image'] ?? ''));
        $merchant->registration_number = trim((string) ($params['registration_number'] ?? ''));
        $registrationNo = trim((string) ($params['registration_no'] ?? ''));
        $merchant->registration_no = $registrationNo === '' ? null : $registrationNo;
        $merchant->points_per_rm = $this->resolvePointsPerRm($params['points_per_rm'] ?? null);
        $merchant->email = trim((string) ($params['email'] ?? ''));
        $merchant->phone = trim((string) ($params['phone'] ?? ''));
        $merchant->contact_name = trim((string) ($params['contact_name'] ?? ''));
        $merchant->contact_phone = trim((string) ($params['contact_phone'] ?? ''));
        $merchant->contact_email = trim((string) ($params['contact_email'] ?? ''));
        $merchant->status = (int) ($params['status'] ?? 1);
        $merchant->is_recommended = (int) ($params['is_recommended'] ?? 0) === 1 ? 1 : 0;
    }

    private function resolvePointsPerRm(mixed $value): int
    {
        if ($value === null || $value === '') {
            throw new AppException('Please enter points per RM commission');
        }

        if (! is_numeric($value) || (int) $value != $value) {
            throw new AppException('Points per RM commission must be an integer');
        }

        $pointsPerRm = (int) $value;
        if ($pointsPerRm <= 0) {
            throw new AppException('Points per RM commission must be greater than 0');
        }

        return $pointsPerRm;
    }

    private function nullableDecimal(mixed $value): ?string
    {
        if ($value === null || $value === '') {
            return null;
        }

        return (string) $value;
    }

    private function dispatchNewMerchantNearbyNotify(MerchantModel $merchant): void
    {
        if ((int) $merchant->status !== 1) {
            return;
        }

        if ($merchant->latitude === null || $merchant->longitude === null
            || $merchant->latitude === '' || $merchant->longitude === '') {
            return;
        }

        $latitude = (float) $merchant->latitude;
        $longitude = (float) $merchant->longitude;

        if ($latitude < -90 || $latitude > 90 || $longitude < -180 || $longitude > 180) {
            return;
        }

        queue('default')->push(new NewMerchantNearbyBroadcastJob(
            (int) $merchant->id,
            $latitude,
            $longitude
        ));
    }

    private function resolveCategoryId(mixed $value): ?int
    {
        if ($value === null || $value === '') {
            return null;
        }

        $categoryId = (int) $value;
        if (! MerchantCategoryModel::query()->whereKey($categoryId)->exists()) {
            throw new AppException('Merchant category not found');
        }

        return $categoryId;
    }

    private function assertEmailUnique(string $email, ?int $excludeId = null): void
    {
        if ($email === '') {
            throw new AppException('Email is required');
        }

        $query = MerchantModel::withTrashed()->where('email', $email);
        if ($excludeId !== null) {
            $query->where('id', '<>', $excludeId);
        }

        if ($query->exists()) {
            throw new AppException('Email already exists');
        }
    }

    private function findOrFail(int $id): MerchantModel
    {
        $merchant = MerchantModel::query()->find($id);
        if (! $merchant) {
            throw new AppException('Merchant not found');
        }

        return $merchant;
    }

    /**
     * 将商家集合映射为带距离的 App 列表项，并按距离升序排序。
     *
     * @param \Hyperf\Collection\Collection<int, MerchantModel> $merchants
     * @return \Hyperf\Collection\Collection<int, array<string, mixed>>
     */
    private function mapMerchantsWithDistance($merchants, float $latitude, float $longitude)
    {
        return $merchants->map(function (MerchantModel $merchant) use ($latitude, $longitude) {
            $distance = null;
            if ($merchant->latitude !== null && $merchant->longitude !== null
                && $merchant->latitude !== '' && $merchant->longitude !== '') {
                $distance = $this->haversineKm(
                    $latitude,
                    $longitude,
                    (float) $merchant->latitude,
                    (float) $merchant->longitude
                );
            }

            return [
                'id' => $merchant->id,
                'name' => $merchant->name,
                'address' => $merchant->address,
                'image' => env('APP_URL') . $merchant->image,
                'category_id' => $merchant->category_id,
                'distance' => $distance,
            ];
        })->sortBy(fn (array $item) => $item['distance'] ?? PHP_FLOAT_MAX)
            ->values();
    }

    /**
     * App 端启用商家基础查询，可按分类筛选。
     */
    private function appActiveMerchantQuery(?int $categoryId = null)
    {
        return MerchantModel::query()
            ->where('status', 1)
            ->when($categoryId !== null, fn ($query) => $query->where('category_id', $categoryId));
    }

    /**
     * 对已排序的列表项做分页。
     *
     * @param \Hyperf\Collection\Collection<int, array<string, mixed>> $items
     */
    private function paginateSortedItems($items, int $page, int $limit): array
    {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 10;

        $total = $items->count();
        $paged = $items->forPage($page, $limit)->values()->all();

        return [
            'items' => $paged,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * Haversine 公式计算两点距离（km），保留 2 位小数。
     */
    private function haversineKm(float $lat1, float $lng1, float $lat2, float $lng2): float
    {
        $earthRadius = 6371.0;
        $latDelta = deg2rad($lat2 - $lat1);
        $lngDelta = deg2rad($lng2 - $lng1);

        $a = sin($latDelta / 2) ** 2
            + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($lngDelta / 2) ** 2;
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return round($earthRadius * $c, 2);
    }
}
