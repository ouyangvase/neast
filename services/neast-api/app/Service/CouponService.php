<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\CouponCategoryModel;
use App\Model\CouponMerchantModel;
use App\Model\CouponModel;
use App\Model\MerchantModel;
use App\Model\UserCouponModel;
use App\Model\UserModel;
use Carbon\Carbon;
use Hyperf\Database\Exception\QueryException;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Contract\RequestInterface;

class CouponService
{
    #[Inject]
    protected UserPointsService $userPointsService;

    #[Inject]
    protected PointsLogService $pointsLogService;

    private const USER_COUPON_SN_CHARSET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    private const USER_COUPON_SN_LENGTH = 6;

    private const USER_COUPON_SN_MAX_ATTEMPTS = 8;

    /**
     * 优惠券列表
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $keyword = trim((string) $request->input('keyword', ''));
        $status = $request->input('status', null);
        $categoryId = $request->input('category_id', null);

        $query = CouponModel::query()->with(['category:id,name']);

        if ($keyword !== '') {
            $query->where('name', 'like', "%{$keyword}%");
        }

        if ($status !== null && $status !== '') {
            $query->where('status', (int) $status);
        }

        if ($categoryId !== null && $categoryId !== '') {
            $query->where('category_id', (int) $categoryId);
        }

        $reviewStatus = $request->input('review_status', null);
        if ($reviewStatus !== null && $reviewStatus !== '') {
            $query->where('review_status', $reviewStatus);
        }

        $total = (clone $query)->count();

        $coupons = $query->orderBy('id', 'desc')
            ->with(['category:id,name', 'merchants.merchant:id,name'])
            ->forPage($page, $limit)
            ->get();

        $merchantIdsMap = $coupons->mapWithKeys(fn (CouponModel $coupon) => [
            $coupon->id => $coupon->merchants->pluck('merchant_id')->map(fn ($id) => (int) $id)->values()->all(),
        ])->all();
        $merchantNameMap = $coupons->flatMap(fn (CouponModel $coupon) => $coupon->merchants)
            ->map(fn (CouponMerchantModel $item) => $item->merchant)
            ->filter()
            ->unique('id')
            ->pluck('name', 'id')
            ->map(fn ($name) => (string) $name)
            ->all();

        $items = $coupons
            ->map(fn (CouponModel $coupon) => $this->formatCoupon(
                $coupon,
                $merchantIdsMap[$coupon->id] ?? [],
                $merchantNameMap
            ))
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 优惠券详情
     */
    public function detail(int $id): array
    {
        $coupon = $this->findOrFail($id);
        $coupon->load(['category:id,name', 'merchants.merchant:id,name']);
        $merchantIds = $coupon->merchants->pluck('merchant_id')->map(fn ($id) => (int) $id)->values()->all();

        return $this->formatCoupon(
            $coupon,
            $merchantIds,
            $coupon->merchants->map(fn (CouponMerchantModel $item) => $item->merchant)
                ->filter()
                ->pluck('name', 'id')
                ->map(fn ($name) => (string) $name)
                ->all()
        );
    }

    /**
     * App 端优惠券分类列表
     */
    public function appCategories(): array
    {
        $items = CouponCategoryModel::query()
            ->orderBy('id', 'asc')
            ->get(['id', 'name'])
            ->map(fn (CouponCategoryModel $category) => [
                'id' => $category->id,
                'name' => $category->name,
            ])
            ->all();

        return ['items' => $items];
    }

    /**
     * App 端优惠券列表（可按分类筛选，分页）
     */
    public function appList(
        int $userId,
        ?int $categoryId = null,
        int $page = 1,
        int $limit = 10
    ): array {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 10;

        $query = CouponModel::query()
            ->where('status', 1)
            ->where('review_status', 'approved')
            ->orderBy('id', 'desc');

        if ($categoryId !== null && $categoryId > 0) {
            $query->where('category_id', $categoryId);
        }

        $total = (clone $query)->count();

        $coupons = $query->forPage($page, $limit)
            ->with(['category:id,name', 'merchants.merchant:id,name'])
            ->get([
            'id',
            'name',
            'required_points',
            'valid_days',
            'category_id',
            'image',
            'redeem_limit',
            'usage_condition',
            'discount_amount',
        ]);

        $merchantIdsMap = $coupons->mapWithKeys(fn (CouponModel $coupon) => [
            $coupon->id => $coupon->merchants->pluck('merchant_id')->map(fn ($id) => (int) $id)->values()->all(),
        ])->all();
        $merchantNameMap = $coupons->flatMap(fn (CouponModel $coupon) => $coupon->merchants)
            ->map(fn (CouponMerchantModel $item) => $item->merchant)
            ->filter()
            ->unique('id')
            ->pluck('name', 'id')
            ->map(fn ($name) => (string) $name)
            ->all();
        $recordMap = $this->getUserUnusedRecordMap($userId);

        $items = $coupons
            ->map(function (CouponModel $coupon) use (
                $merchantIdsMap,
                $merchantNameMap,
                $recordMap
            ) {
                $record = $recordMap[$coupon->id] ?? null;

                return $this->formatAppListItem(
                    $coupon,
                    $merchantIdsMap[$coupon->id] ?? [],
                    $merchantNameMap,
                    $record !== null,
                    $record['expire_at'] ?? null,
                    $record['sn'] ?? null,
                    $record['qrcode'] ?? null
                );
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
     * App 端商家可用优惠券列表（不含 fully_redeemed）
     */
    public function appListByMerchant(int $userId, int $merchantId): array
    {
        $couponIds = CouponMerchantModel::query()
            ->where('merchant_id', $merchantId)
            ->orderBy('id', 'asc')
            ->pluck('coupon_id')
            ->map(fn ($id) => (int) $id)
            ->all();

        if ($couponIds === []) {
            return ['items' => []];
        }

        $coupons = CouponModel::query()
            ->where('status', 1)
            ->where('review_status', 'approved')
            ->whereIn('id', $couponIds)
            ->orderBy('id', 'desc')
            ->with(['category:id,name', 'merchants.merchant:id,name'])
            ->get([
                'id',
                'name',
                'required_points',
                'valid_days',
                'category_id',
                'image',
                'redeem_limit',
                'usage_condition',
                'discount_amount',
            ]);

        $merchantIdsMap = $coupons->mapWithKeys(fn (CouponModel $coupon) => [
            $coupon->id => $coupon->merchants->pluck('merchant_id')->map(fn ($id) => (int) $id)->values()->all(),
        ])->all();
        $merchantNameMap = $coupons->flatMap(fn (CouponModel $coupon) => $coupon->merchants)
            ->map(fn (CouponMerchantModel $item) => $item->merchant)
            ->filter()
            ->unique('id')
            ->pluck('name', 'id')
            ->map(fn ($name) => (string) $name)
            ->all();
        $recordMap = $this->getUserUnusedRecordMap($userId);

        $items = $coupons
            ->map(function (CouponModel $coupon) use (
                $merchantIdsMap,
                $merchantNameMap,
                $recordMap
            ) {
                $record = $recordMap[$coupon->id] ?? null;

                return $this->formatAppListItem(
                    $coupon,
                    $merchantIdsMap[$coupon->id] ?? [],
                    $merchantNameMap,
                    $record !== null,
                    $record['expire_at'] ?? null,
                    $record['sn'] ?? null,
                    $record['qrcode'] ?? null
                );
            })
            ->filter(fn (array $item) => $item['action_status'] !== 'fully_redeemed')
            ->values()
            ->all();

        return ['items' => $items];
    }

    /**
     * App 端我的可用优惠券数量（未使用且未过期）
     */
    public function appMyCount(int $userId): array
    {
        $count = $this->applyMyCouponStatusFilter(
            UserCouponModel::query()->where('user_id', $userId),
            'active'
        )->count();

        return ['count' => $count];
    }

    /**
     * App 端我的优惠券列表（分页，按状态筛选）
     */
    public function appMyList(
        int $userId,
        int $page = 1,
        int $limit = 10,
        string $status = 'active'
    ): array {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 10;
        $status = $this->normalizeMyCouponStatus($status);

        $query = $this->applyMyCouponStatusFilter(
            UserCouponModel::query()->where('user_id', $userId),
            $status
        )->orderBy('id', 'desc');

        $total = (clone $query)->count();

        $userCoupons = $query->forPage($page, $limit)->get();

        if ($userCoupons->isEmpty()) {
            return [
                'items' => [],
                'total' => $total,
                'page' => $page,
                'limit' => $limit,
            ];
        }

        $couponIds = $userCoupons
            ->pluck('coupon_id')
            ->map(fn ($id) => (int) $id)
            ->unique()
            ->values()
            ->all();

        $coupons = CouponModel::query()
            ->whereIn('id', $couponIds)
            ->get(['id', 'valid_days', 'category_id', 'usage_condition', 'name', 'image'])
            ->keyBy('id');

        // 用户券 merchant_ids 快照
        $merchantIdsByUserCouponId = [];
        $allMerchantIds = [];

        foreach ($userCoupons as $userCoupon) {
            $merchantIds = $this->parseSnapshotMerchantIds((string) $userCoupon->merchant_ids);
            $merchantIdsByUserCouponId[(int) $userCoupon->id] = $merchantIds;

            foreach ($merchantIds as $merchantId) {
                $allMerchantIds[$merchantId] = $merchantId;
            }
        }

        $merchantNameMap = [];
        if ($allMerchantIds !== []) {
            $merchantNameMap = MerchantModel::query()
                ->whereIn('id', array_values($allMerchantIds))
                ->pluck('name', 'id')
                ->map(fn ($name) => (string) $name)
                ->all();
        }

        $items = [];
        foreach ($userCoupons as $userCoupon) {
            $coupon = $coupons->get($userCoupon->coupon_id);
            if (! $coupon) {
                continue;
            }

            $merchantIds = $merchantIdsByUserCouponId[(int) $userCoupon->id] ?? [];
            $merchantNames = [];
            foreach ($merchantIds as $merchantId) {
                $name = $merchantNameMap[$merchantId] ?? '';
                if ($name !== '') {
                    $merchantNames[] = $name;
                }
            }

            $couponStatus = $this->resolveUserCouponStatus($userCoupon);

            $items[] = [
                'user_coupon_id' => (int) $userCoupon->id,
                'id' => $coupon->id,
                'name' => $userCoupon->name !== '' ? $userCoupon->name : $coupon->name,
                'required_points' => (int) $userCoupon->used_points,
                'valid_days' => $coupon->valid_days,
                'category_id' => $coupon->category_id,
                'usage_condition' => $userCoupon->usage_condition ?? $coupon->usage_condition ?? '',
                'discount_amount' => (string) $userCoupon->discount_amount,
                'merchant_names' => $merchantNames,
                'image' => file_url($coupon->image ?? ''),
                'expire_at' => (string) $userCoupon->expire_at,
                'redeemed_at' => $userCoupon->redeemed_at ? (string) $userCoupon->redeemed_at : null,
                'coupon_status' => $couponStatus,
                'sn' => (string) $userCoupon->sn,
                'qrcode' => (string) $userCoupon->redeem_token,
                'action_status' => $couponStatus === 'active' ? 'use_now' : 'use_now',
            ];
        }

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * App 端最新启用优惠券（按 id 降序取一条）
     */
    public function appLatest(): ?array
    {
        $coupon = CouponModel::query()
            ->where('status', 1)
            ->where('review_status', 'approved')
            ->orderBy('id', 'desc')
            ->first(['id', 'name', 'required_points', 'image']);

        if (! $coupon) {
            return null;
        }

        return [
            'id' => $coupon->id,
            'name' => $coupon->name,
            'required_points' => $coupon->required_points,
            'image' => file_url($coupon->image ?? ''),
        ];
    }

    /**
     * App 端兑换优惠券
     */
    public function appRedeem(int $userId, int $couponId): array
    {
        return Db::transaction(function () use ($userId, $couponId) {
            $coupon = CouponModel::query()
                ->lockForUpdate()
                ->with(['merchants.merchant:id,name'])
                ->find($couponId);
            if (! $coupon || (int) $coupon->status !== 1 || $coupon->review_status !== 'approved') {
                throw new AppException('Coupon not found');
            }

            $hasUnused = UserCouponModel::query()
                ->where('user_id', $userId)
                ->where('coupon_id', $couponId)
                ->where('status', UserCouponModel::STATUS_UNUSED)
                ->exists();

            if ($hasUnused) {
                throw new AppException('You have already redeemed this coupon');
            }

            if ($coupon->redeem_limit !== null && (int) $coupon->redeem_limit === 0) {
                throw new AppException('This coupon is fully redeemed');
            }

            $requiredPoints = (int) $coupon->required_points;
            if ($requiredPoints > 0) {
                $this->userPointsService->deduct($userId, $requiredPoints);
                $this->pointsLogService->log(
                    $userId,
                    -$requiredPoints,
                    'Redeem Reward',
                    (string) $coupon->name
                );
            }

            $merchantIds = $coupon->merchants->pluck('merchant_id')->map(fn ($id) => (int) $id)->values()->all();
            $merchantIds = array_values(array_unique(array_filter(
                $merchantIds,
                fn (int $merchantId) => $merchantId > 0
            )));

            $validDays = max(0, (int) $coupon->valid_days);
            $expireAt = Carbon::now()->addDays($validDays)->format('Y-m-d H:i:s');

            $userCoupon = new UserCouponModel();
            $userCoupon->user_id = $userId;
            $userCoupon->coupon_id = $couponId;
            $userCoupon->used_points = (int) $coupon->required_points;
            $userCoupon->expire_at = $expireAt;
            $userCoupon->discount_amount = (string) $coupon->discount_amount;
            $userCoupon->name = (string) $coupon->name;
            $userCoupon->usage_condition = $coupon->usage_condition ?? '';
            $userCoupon->merchant_ids = implode(',', $merchantIds);
            $userCoupon->status = UserCouponModel::STATUS_UNUSED;

            if ($coupon->redeem_limit !== null) {
                $coupon->redeem_limit = (int) $coupon->redeem_limit - 1;
                $coupon->save();
            }

            $this->saveUserCouponWithUniqueCodes($userCoupon);

            return [
                'item' => $this->buildAppListItemByCouponId(
                    $userId,
                    $coupon,
                    $expireAt,
                    (string) $userCoupon->sn,
                    (string) $userCoupon->redeem_token
                ),
            ];
        });
    }

    /**
     * 创建优惠券
     */
    public function create(array $params): array
    {
        $merchantIds = $this->normalizeMerchantIds($params['merchant_ids'] ?? []);
        $this->assertCategoryExists((int) ($params['category_id'] ?? 0));
        $this->assertMerchantsExist($merchantIds);

        return Db::transaction(function () use ($params, $merchantIds) {
            $coupon = new CouponModel();
            $this->fillCoupon($coupon, $params);
            $coupon->origin = 'admin';
            $coupon->review_status = 'approved';
            $coupon->save();
            $this->syncMerchantRelations($coupon->id, $merchantIds);
            $coupon->load(['category:id,name']);

            return $this->formatCoupon(
                $coupon,
                $merchantIds,
                $this->getMerchantNameMap($merchantIds)
            );
        });
    }

    /**
     * 商家提交自己的优惠券，待管理员审核后才对用户可见
     */
    public function merchantSubmit(int $merchantId, array $params): array
    {
        $this->assertCategoryExists((int) ($params['category_id'] ?? 0));

        return Db::transaction(function () use ($params, $merchantId) {
            $coupon = new CouponModel();
            $this->fillCoupon($coupon, $params);
            $coupon->origin = 'merchant';
            $coupon->review_status = 'pending';
            $coupon->status = 0;
            $coupon->save();
            $this->syncMerchantRelations($coupon->id, [$merchantId]);
            $coupon->load(['category:id,name']);

            return $this->formatCoupon(
                $coupon,
                [$merchantId],
                $this->getMerchantNameMap([$merchantId])
            );
        });
    }

    /**
     * 更新优惠券
     */
    public function update(int $id, array $params): array
    {
        $coupon = $this->findOrFail($id);
        $merchantIds = $this->normalizeMerchantIds($params['merchant_ids'] ?? []);
        $this->assertCategoryExists((int) ($params['category_id'] ?? 0));
        $this->assertMerchantsExist($merchantIds);

        return Db::transaction(function () use ($coupon, $params, $merchantIds) {
            $this->fillCoupon($coupon, $params);
            $coupon->save();
            $this->syncMerchantRelations($coupon->id, $merchantIds);
            $coupon->load(['category:id,name']);

            return $this->formatCoupon(
                $coupon,
                $merchantIds,
                $this->getMerchantNameMap($merchantIds)
            );
        });
    }

    /**
     * 删除优惠券
     */
    public function delete(int $id): void
    {
        $coupon = $this->findOrFail($id);

        Db::transaction(function () use ($coupon) {
            CouponMerchantModel::query()->where('coupon_id', $coupon->id)->delete();
            $coupon->delete();
        });
    }

    /**
     * 状态切换
     */
    public function toggleStatus(int $id, int $status): void
    {
        $coupon = $this->findOrFail($id);
        $coupon->status = $status === 1 ? 1 : 0;
        $coupon->save();
    }

    /**
     * 审核商家提交的优惠券。管理员创建的券不走此接口。
     */
    public function review(int $id, string $result): array
    {
        $coupon = $this->findOrFail($id);
        if ($coupon->origin !== 'merchant') {
            throw new AppException('Only merchant-submitted coupons can be reviewed');
        }

        if ($result === 'approved') {
            $coupon->review_status = 'approved';
            $coupon->status = 1;
        } else {
            $coupon->review_status = 'rejected';
            $coupon->status = 0;
        }
        $coupon->save();

        return $this->detail($id);
    }

    /**
     * @param int[] $merchantIds
     */
    private function syncMerchantRelations(int $couponId, array $merchantIds): void
    {
        CouponMerchantModel::query()->where('coupon_id', $couponId)->delete();

        if ($merchantIds === []) {
            return;
        }

        $rows = array_map(
            fn (int $merchantId) => [
                'coupon_id' => $couponId,
                'merchant_id' => $merchantId,
            ],
            $merchantIds
        );

        CouponMerchantModel::query()->insert($rows);
    }

    /**
     * @param int[] $merchantIds
     * @return array<int, string>
     */
    private function getMerchantNameMap(array $merchantIds): array
    {
        $merchantIds = array_values(array_unique(array_filter(
            $merchantIds,
            fn (int $id) => $id > 0
        )));

        if ($merchantIds === []) {
            return [];
        }

        return MerchantModel::query()
            ->whereIn('id', $merchantIds)
            ->pluck('name', 'id')
            ->map(fn ($name) => (string) $name)
            ->all();
    }

    private function fillCoupon(CouponModel $coupon, array $params): void
    {
        $coupon->name = trim((string) ($params['name'] ?? ''));
        $coupon->required_points = (int) ($params['required_points'] ?? 0);
        $coupon->valid_days = (int) ($params['valid_days'] ?? 0);
        $coupon->discount_amount = (string) ($params['discount_amount'] ?? '0');
        $coupon->usage_condition = trim((string) ($params['usage_condition'] ?? ''));
        $coupon->status = (int) ($params['status'] ?? 1);
        $coupon->redeem_limit = $this->normalizeRedeemLimit($params['redeem_limit'] ?? null);
        $coupon->category_id = (int) ($params['category_id'] ?? 0);
        $coupon->image = trim((string) ($params['image'] ?? ''));
    }

    private function normalizeRedeemLimit(mixed $value): ?int
    {
        if ($value === null || $value === '') {
            return null;
        }

        return (int) $value;
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

    private function assertCategoryExists(int $categoryId): void
    {
        if ($categoryId <= 0) {
            throw new AppException('Category is required');
        }

        if (! CouponCategoryModel::query()->where('id', $categoryId)->exists()) {
            throw new AppException('Category not found');
        }
    }

    /**
     * @param int[] $merchantIds
     */
    private function assertMerchantsExist(array $merchantIds): void
    {
        if ($merchantIds === []) {
            throw new AppException('Please select at least one merchant');
        }

        $count = MerchantModel::query()->whereIn('id', $merchantIds)->count();
        if ($count !== count($merchantIds)) {
            throw new AppException('Merchant not found');
        }
    }

    /**
     * @param int[] $merchantIds
     * @param array<int, string> $merchantNameMap
     */
    private function formatCoupon(
        CouponModel $coupon,
        array $merchantIds,
        array $merchantNameMap
    ): array {
        $data = $coupon->toArray();
        unset($data['category']);
        $data['category_name'] = $coupon->category?->name ?? '';
        $data['merchant_ids'] = $merchantIds;
        $data['merchant_names'] = array_map(
            fn (int $merchantId) => $merchantNameMap[$merchantId] ?? '',
            $merchantIds
        );

        return $data;
    }

    private function normalizeMyCouponStatus(string $status): string
    {
        return match ($status) {
            'used', 'expired' => $status,
            default => 'active',
        };
    }

    /**
     * @param \Hyperf\Database\Model\Builder|UserCouponModel $query
     */
    private function applyMyCouponStatusFilter($query, string $status)
    {
        return match ($status) {
            'used' => $query->where('status', UserCouponModel::STATUS_USED),
            'expired' => $query
                ->where('status', UserCouponModel::STATUS_UNUSED)
                ->where('expire_at', '<=', Carbon::now()->format('Y-m-d H:i:s')),
            default => $query
                ->where('status', UserCouponModel::STATUS_UNUSED)
                ->where('expire_at', '>', Carbon::now()->format('Y-m-d H:i:s')),
        };
    }

    private function resolveUserCouponStatus(UserCouponModel $userCoupon): string
    {
        if ((int) $userCoupon->status === UserCouponModel::STATUS_USED) {
            return 'used';
        }

        if (Carbon::parse((string) $userCoupon->expire_at)->lte(Carbon::now())) {
            return 'expired';
        }

        return 'active';
    }

    private function findOrFail(int $id): CouponModel
    {
        $coupon = CouponModel::query()->find($id);
        if (! $coupon) {
            throw new AppException('Coupon not found');
        }

        return $coupon;
    }

    private function resolveAppActionStatus(CouponModel $coupon, bool $hasUnusedRecord): string
    {
        if ($hasUnusedRecord) {
            return 'use_now';
        }

        if ($coupon->redeem_limit !== null && (int) $coupon->redeem_limit === 0) {
            return 'fully_redeemed';
        }

        return 'redeem';
    }

    /**
     * @return array<int, array{expire_at: string, sn: string, qrcode: string}>
     */
    private function getUserUnusedRecordMap(int $userId): array
    {
        $map = [];

        $rows = UserCouponModel::query()
            ->where('user_id', $userId)
            ->where('status', UserCouponModel::STATUS_UNUSED)
            ->orderBy('id', 'desc')
            ->get(['id', 'user_id', 'coupon_id', 'expire_at', 'sn', 'redeem_token']);

        foreach ($rows as $row) {
            $couponId = (int) $row->coupon_id;
            if (isset($map[$couponId])) {
                continue;
            }

            $expireAt = (string) $row->expire_at;
            $map[$couponId] = [
                'expire_at' => $expireAt,
                'sn' => (string) $row->sn,
                'qrcode' => (string) $row->redeem_token,
            ];
        }

        return $map;
    }

    private function buildAppListItemByCouponId(
        int $userId,
        CouponModel $coupon,
        ?string $expireAt = null,
        ?string $sn = null,
        ?string $redeemToken = null
    ): array {
        $coupon->loadMissing(['category:id,name', 'merchants.merchant:id,name']);
        $merchantIds = $coupon->merchants->pluck('merchant_id')->map(fn ($id) => (int) $id)->values()->all();
        $merchantNameMap = $coupon->merchants->map(fn (CouponMerchantModel $item) => $item->merchant)
            ->filter()
            ->pluck('name', 'id')
            ->map(fn ($name) => (string) $name)
            ->all();

        if ($expireAt === null || $sn === null || $redeemToken === null) {
            $record = UserCouponModel::query()
                ->where('user_id', $userId)
                ->where('coupon_id', $coupon->id)
                ->where('status', UserCouponModel::STATUS_UNUSED)
                ->orderBy('id', 'desc')
                ->first(['id', 'expire_at', 'sn', 'redeem_token']);

            if ($record) {
                $expireAt ??= (string) $record->expire_at;
                $sn ??= (string) $record->sn;
                $redeemToken ??= (string) $record->redeem_token;
            }
        }

        $hasUnusedRecord = $expireAt !== null && $expireAt !== '';

        return $this->formatAppListItem(
            $coupon,
            $merchantIds,
            $merchantNameMap,
            $hasUnusedRecord,
            $expireAt,
            $sn,
            $redeemToken
        );
    }

    /**
     * @param int[] $merchantIds
     * @param array<int, string> $merchantNameMap
     */
    private function formatAppListItem(
        CouponModel $coupon,
        array $merchantIds,
        array $merchantNameMap,
        bool $hasUnusedRecord,
        ?string $expireAt,
        ?string $sn = null,
        ?string $redeemToken = null
    ): array {
        $merchantNames = array_values(array_filter(array_map(
            fn (int $merchantId) => $merchantNameMap[$merchantId] ?? '',
            $merchantIds
        )));

        return [
            'id' => $coupon->id,
            'name' => $coupon->name,
            'required_points' => $coupon->required_points,
            'valid_days' => $coupon->valid_days,
            'category_id' => $coupon->category_id,
            'category_name' => $coupon->category?->name ?? '',
            'image' => file_url($coupon->image ?? ''),
            'usage_condition' => $coupon->usage_condition ?? '',
            'discount_amount' => (string) $coupon->discount_amount,
            'merchant_names' => $merchantNames,
            'expire_at' => $hasUnusedRecord ? $expireAt : null,
            'sn' => $hasUnusedRecord ? ($sn ?? '') : '',
            'qrcode' => $hasUnusedRecord ? ($redeemToken ?? '') : '',
            'action_status' => $this->resolveAppActionStatus($coupon, $hasUnusedRecord),
        ];
    }

    /**
     * 商家端校验优惠券（扫码 token 或手输 SN）
     */
    public function merchantVerifyByCode(int $merchantId, string $code): array
    {
        $userCoupon = $this->findUserCouponByCode($code);
        $userCoupon->loadMissing('user');
        $this->assertMerchantCanUseUserCoupon($userCoupon, $merchantId);

        return $this->formatMerchantUserCouponPreview($userCoupon);
    }

    /**
     * 商家端核销优惠券（校验逻辑同 verify）
     */
    public function merchantRedeemByCode(int $merchantId, string $code): array
    {
        return Db::transaction(function () use ($merchantId, $code) {
            $userCoupon = $this->findUserCouponByCode($code, true);
            $this->assertMerchantCanUseUserCoupon($userCoupon, $merchantId);

            $redeemedAt = Carbon::now()->format('Y-m-d H:i:s');
            $userCoupon->status = UserCouponModel::STATUS_USED;
            $userCoupon->redeemed_merchant_id = $merchantId;
            $userCoupon->redeemed_at = $redeemedAt;
            $userCoupon->save();

            $userCoupon->loadMissing('user');
            $preview = $this->formatMerchantUserCouponPreview($userCoupon);
            $preview['redeemed_merchant_id'] = $merchantId;
            $preview['redeemed_at'] = $redeemedAt;

            return $preview;
        });
    }

    private function findUserCouponByCode(string $code, bool $lockForUpdate = false): UserCouponModel
    {
        $code = trim($code);
        if ($code === '') {
            throw new AppException('Invalid coupon code');
        }

        $query = UserCouponModel::query();
        if ($lockForUpdate) {
            $query->lockForUpdate();
        }

        if (preg_match('/^[a-f0-9]{32}$/i', $code) === 1) {
            $query->where('redeem_token', strtolower($code));
        } else {
            $sn = strtoupper($code);
            if (preg_match('/^[A-Z0-9]{6}$/', $sn) !== 1) {
                throw new AppException('Invalid coupon code');
            }
            $query->where('sn', $sn);
        }

        $userCoupon = $query->first();
        if (! $userCoupon) {
            throw new AppException('Coupon not found');
        }

        return $userCoupon;
    }

    private function assertMerchantCanUseUserCoupon(UserCouponModel $userCoupon, int $merchantId): void
    {
        if ((int) $userCoupon->status !== UserCouponModel::STATUS_UNUSED) {
            throw new AppException('Coupon already used');
        }

        if (Carbon::parse((string) $userCoupon->expire_at)->lte(Carbon::now())) {
            throw new AppException('Coupon expired');
        }

        $merchantIds = $this->parseSnapshotMerchantIds((string) $userCoupon->merchant_ids);
        if ($merchantIds === [] || ! in_array($merchantId, $merchantIds, true)) {
            throw new AppException('Coupon not valid at this outlet');
        }
    }

    private function formatMerchantUserCouponPreview(UserCouponModel $userCoupon): array
    {
        $merchantIds = $this->parseSnapshotMerchantIds((string) $userCoupon->merchant_ids);
        $merchantNameMap = $this->getMerchantNameMap($merchantIds);
        $merchantNames = array_values(array_filter(array_map(
            fn (int $id) => $merchantNameMap[$id] ?? '',
            $merchantIds
        )));

        $user = $userCoupon->user;
        $customerName = trim(trim((string) ($user->first_name ?? '')) . ' ' . trim((string) ($user->last_name ?? '')));
        if ($customerName === '') {
            $customerName = '-';
        }

        return [
            'user_coupon_id' => (int) $userCoupon->id,
            'sn' => (string) $userCoupon->sn,
            'name' => (string) $userCoupon->name,
            'discount_amount' => (string) $userCoupon->discount_amount,
            'used_points' => (int) $userCoupon->used_points,
            'expire_at' => (string) $userCoupon->expire_at,
            'merchant_names' => $merchantNames,
            'customer_name' => $customerName,
            'contact' => $this->maskUserAccount($user),
        ];
    }

    private function generateUserCouponSn(): string
    {
        $charset = self::USER_COUPON_SN_CHARSET;
        $length = strlen($charset) - 1;
        $sn = '';

        for ($i = 0; $i < self::USER_COUPON_SN_LENGTH; $i++) {
            $sn .= $charset[random_int(0, $length)];
        }

        return $sn;
    }

    private function generateUserCouponRedeemToken(): string
    {
        return bin2hex(random_bytes(16));
    }

    private function saveUserCouponWithUniqueCodes(UserCouponModel $userCoupon): void
    {
        for ($attempt = 0; $attempt < self::USER_COUPON_SN_MAX_ATTEMPTS; $attempt++) {
            $userCoupon->sn = $this->generateUserCouponSn();
            $userCoupon->redeem_token = $this->generateUserCouponRedeemToken();

            try {
                $userCoupon->save();

                return;
            } catch (\Throwable $e) {
                if (! $this->isDuplicateUserCouponCodeError($e)) {
                    throw $e;
                }
            }
        }

        throw new AppException('Failed to generate coupon code');
    }

    private function isDuplicateUserCouponCodeError(\Throwable $e): bool
    {
        if ($e instanceof QueryException) {
            $message = $e->getMessage();

            return str_contains($message, '1062')
                || str_contains($message, 'Duplicate entry')
                || str_contains($message, 'uk_sn')
                || str_contains($message, 'uk_redeem_token');
        }

        return false;
    }

    private function maskUserAccount(?UserModel $user): string
    {
        if ($user === null) {
            return '-';
        }

        $account = trim((string) $user->account);
        if ($account === '') {
            return '-';
        }

        if (strlen($account) <= 5) {
            return $account;
        }

        return substr($account, 0, 2) . '****' . substr($account, -3);
    }

    /**
     * @return int[]
     */
    private function parseSnapshotMerchantIds(string $merchantIds): array
    {
        $merchantIds = trim($merchantIds);
        if ($merchantIds === '') {
            return [];
        }

        return array_values(array_unique(array_filter(array_map(
            fn (string $id) => (int) trim($id),
            explode(',', $merchantIds)
        ), fn (int $id) => $id > 0)));
    }
}
