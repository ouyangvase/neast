<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\LandlordModel;
use App\Model\LandlordPropertyModel;
use App\Model\RentHistoryModel;
use App\Model\RentModel;
use Carbon\Carbon;
use Hyperf\Context\Context;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Contract\RequestInterface;

class RentService
{
    #[Inject]
    protected PointsSettingService $pointsSettingService;

    #[Inject]
    protected RentHistoryService $historyService;

    /**
     * App 端租金列表
     */
    public function appList(int $userId, int $page, int $limit): array
    {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 20;

        $multiplier = (float) ($this->pointsSettingService->get()['rent_points_multiplier'] ?? 1);

        $query = RentModel::query()
            ->with(['landlord:id,name', 'property:id,name,image'])
            ->where('user_id', $userId)
            ->where('status', '!=', RentModel::STATUS_TERMINATED);

        $total = (clone $query)->count();

        $rents = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get();

        $rentIds = $rents->pluck('id')->map(fn ($id) => (int) $id)->all();
        $payableRentIds = $this->resolvePayableRentIds($rentIds);
        $dueDatesByRentId = $this->historyService->resolveNextPayableDueDatesByRentIds($rentIds);

        $items = $rents
            ->map(function (RentModel $rent) use ($multiplier, $payableRentIds, $dueDatesByRentId) {
                $nextUnpaid = $this->nextUnpaidScheduleDate($rent);
                $dueDate = $dueDatesByRentId[(int) $rent->id] ?? $nextUnpaid;

                return $this->formatAppListItem(
                    $rent,
                    $multiplier,
                    in_array((int) $rent->id, $payableRentIds, true) || $nextUnpaid !== null,
                    $dueDate
                );
            })
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
            'rent_points_multiplier' => $multiplier,
        ];
    }

    /** Earliest lease month that is not paid or settled. */
    public function nextUnpaidScheduleDate(RentModel $rent): ?string
    {
        $leaseMonths = (int) $rent->lease_months;
        if ($leaseMonths < 1 || $rent->first_pay_month === null) {
            return null;
        }

        $covered = [];
        $dates = RentHistoryModel::query()
            ->where('rent_id', $rent->id)
            ->whereIn('status', [RentHistoryModel::STATUS_PAID, RentHistoryModel::STATUS_SETTLED])
            ->pluck('last_paid_date');
        foreach ($dates as $date) {
            $covered[substr((string) $date, 0, 7)] = true;
        }

        foreach ($this->buildPaymentSchedule($rent, $leaseMonths) as $item) {
            $month = substr($item['last_paid_date'], 0, 7);
            if (! isset($covered[$month])) {
                return $item['last_paid_date'];
            }
        }

        return null;
    }

    /**
     * App 首页 Next Rent 卡片
     *
     * @return array<string, mixed>|null
     */
    public function appNextRent(int $userId): ?array
    {
        $history = $this->historyService->findEarliestPayablePending($userId);
        if ($history === null) {
            return null;
        }

        $rent = $history->rent;
        if ($rent === null) {
            return null;
        }

        $multiplier = (float) ($this->pointsSettingService->get()['rent_points_multiplier'] ?? 1);
        return $this->formatAppListItem(
            $rent,
            $multiplier,
            true,
            $this->historyService->extractDateOnly((string) $history->last_paid_date)
        );
    }

    /**
     * 租金列表
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;
        $status = $request->input('status', null);
        $userAccount = trim((string) $request->input('user_account', ''));
        $landlordName = trim((string) $request->input('landlord_name', ''));
        $landlordBankAccount = trim((string) $request->input('landlord_bank_account', ''));
        $startDay = $request->input('start_day', null);
        $endDay = $request->input('end_day', null);

        $query = RentModel::query()
            ->with([
                'user:id,account,first_name,last_name',
                'landlord:id,name',
                'property:id,name,address',
            ]);

        if ($status !== null && $status !== '') {
            $query->where('status', (int) $status);
        }

        if ($userAccount !== '') {
            $query->whereHas('user', function ($userQuery) use ($userAccount) {
                $userQuery->where('account', 'like', "%{$userAccount}%");
            });
        }

        if ($landlordName !== '') {
            $query->whereHas('landlord', function ($landlordQuery) use ($landlordName) {
                $landlordQuery->where('name', 'like', "%{$landlordName}%");
            });
        }

        if ($landlordBankAccount !== '') {
            $query->where(
                'landlord_bank_account',
                'like',
                "%{$landlordBankAccount}%"
            );
        }

        if ($startDay !== null && $startDay !== '') {
            $query->where('paid_at', '>=', $this->normalizePaidDay($startDay));
        }

        if ($endDay !== null && $endDay !== '') {
            $query->where('paid_at', '<=', $this->normalizePaidDay($endDay));
        }

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (RentModel $rent) {
                return $this->formatListItem($rent);
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
     * 审核
     *
     * @param array<string, mixed> $params
     */
    public function audit(int $id, array $params): void
    {
        $rent = $this->findOrFail($id);
        if ((int) $rent->status !== RentModel::STATUS_PENDING) {
            throw new AppException('Only pending records can be reviewed');
        }

        $result = trim((string) ($params['result'] ?? ''));
        if (! in_array($result, ['approved', 'rejected'], true)) {
            throw new AppException('Invalid review result');
        }

        if ($result === 'rejected') {
            $rent->status = RentModel::STATUS_REJECTED;
            $rent->rejected_by = RentModel::REJECTED_BY_ADMIN;
            $rent->save();
            return;
        }

        $landlordBank = trim((string) ($params['landlord_bank'] ?? ''));
        $landlordBankAccount = trim((string) ($params['landlord_bank_account'] ?? ''));
        $landlordAccountName = trim((string) ($params['landlord_account_name'] ?? ''));

        if ($landlordBank === '') {
            $landlordBank = trim((string) $rent->landlord_bank);
        }
        if ($landlordBankAccount === '') {
            $landlordBankAccount = trim((string) $rent->landlord_bank_account);
        }
        if ($landlordAccountName === '') {
            $landlordAccountName = trim((string) $rent->landlord_account_name);
        }

        if ($landlordBank === '' || $landlordBankAccount === '' || $landlordAccountName === '') {
            throw new AppException('Landlord bank information is required for approval');
        }

        $leaseMonths = (int) ($params['lease_months'] ?? 0);
        if ($leaseMonths < 1) {
            throw new AppException('Lease term must be at least 1 month');
        }

        $schedule = $this->buildPaymentSchedule($rent, $leaseMonths);

        $propertyId = (int) ($params['property_id'] ?? 0);
        $createdAt = $rent->created_at !== null
            ? Carbon::parse((string) $rent->created_at)
            : null;

        Db::transaction(function () use (
            $rent,
            $landlordBank,
            $landlordBankAccount,
            $landlordAccountName,
            $propertyId,
            $leaseMonths,
            $schedule,
            $createdAt
        ) {
            if (RentHistoryModel::query()->where('rent_id', $rent->id)->exists()) {
                throw new AppException('Payment schedule already exists');
            }

            if ($propertyId > 0) {
                $property = LandlordPropertyModel::query()->find($propertyId);
                if (! $property) {
                    throw new AppException('Property not found');
                }
                $rent->property_id = $propertyId;
                $rent->landlord_id = (int) $property->landlord_id;
            }

            $rent->landlord_bank = $landlordBank;
            $rent->landlord_bank_account = $landlordBankAccount;
            $rent->landlord_account_name = $landlordAccountName;
            $rent->lease_months = $leaseMonths;
            $rent->expire_date = $this->calculateExpireDate($leaseMonths, $createdAt);
            $rent->status = RentModel::STATUS_APPROVED;
            $rent->save();

            $this->historyService->createBatchForRentAudit($rent, $schedule);
        });
    }

    /**
     * 终止租约：作废未付期次，App/房东端不再展示该租约。
     */
    public function terminate(int $id, string $reason): void
    {
        $rent = $this->findOrFail($id);

        $adminId = (int) (Context::get('auth')?->id ?? 0);
        if ($adminId <= 0) {
            throw new AppException('Admin not found');
        }

        $this->executeTerminate($rent, $reason, $adminId);
    }

    /**
     * App 用户终止自己的租约。
     */
    public function appTerminate(int $userId, int $rentId, string $reason = ''): void
    {
        $rent = RentModel::query()
            ->where('id', $rentId)
            ->where('user_id', $userId)
            ->first();

        if (! $rent) {
            throw new AppException('Rent not found');
        }

        $this->executeTerminate($rent, $reason, null);
    }

    /**
     * 房东端租约详情。
     *
     * @return array<string, mixed>
     */
    public function landlordDetail(int $landlordId, int $rentId): array
    {
        $rent = RentModel::query()
            ->with([
                'user:id,first_name,last_name,avatar',
                'property:id,name,address',
            ])
            ->where('id', $rentId)
            ->where('landlord_id', $landlordId)
            ->where('status', '!=', RentModel::STATUS_TERMINATED)
            ->first();

        if (! $rent) {
            throw new AppException('Rent not found');
        }

        return $this->formatLandlordDetailItem($rent);
    }

    /**
     * 房东终止自己的租约。
     */
    public function landlordTerminate(int $landlordId, int $rentId, string $reason = ''): void
    {
        $rent = RentModel::query()
            ->where('id', $rentId)
            ->where('landlord_id', $landlordId)
            ->first();

        if (! $rent) {
            throw new AppException('Rent not found');
        }

        $this->executeTerminate($rent, $reason, null);
    }

    private function executeTerminate(RentModel $rent, string $reason, ?int $terminatedBy): void
    {
        $status = (int) $rent->status;

        if ($status === RentModel::STATUS_TERMINATED) {
            throw new AppException('Rent is already terminated');
        }

        if (! in_array($status, [RentModel::STATUS_APPROVED, RentModel::STATUS_PENDING_BIND], true)) {
            throw new AppException('Only approved or pending bind records can be terminated');
        }

        Db::transaction(function () use ($rent, $reason, $terminatedBy) {
            RentHistoryModel::query()
                ->where('rent_id', $rent->id)
                ->where('status', RentHistoryModel::STATUS_PENDING)
                ->update(['status' => RentHistoryModel::STATUS_CANCELLED]);

            $rent->status = RentModel::STATUS_TERMINATED;
            $rent->terminated_at = date('Y-m-d H:i:s');
            $rent->terminated_by = $terminatedBy;
            $rent->terminate_reason = mb_substr(trim($reason), 0, 255);
            $rent->save();
        });
    }

    /**
     * 审核前交租计划预览
     *
     * @return array<string, mixed>
     */
    public function paymentSchedulePreview(int $id, ?int $leaseMonths = null): array
    {
        $rent = $this->findOrFail($id);
        if ((int) $rent->status !== RentModel::STATUS_PENDING) {
            throw new AppException('Only pending records can be previewed');
        }

        $months = $leaseMonths ?? (int) $rent->lease_months;
        if ($months < 1) {
            throw new AppException('Lease term must be at least 1 month');
        }

        return [
            'lease_months' => $months,
            'items' => $this->buildPaymentSchedule($rent, $months),
        ];
    }

    /**
     * 生成交租计划
     *
     * @return array<int, array{amount: string, last_paid_date: string}>
     */
    public function buildPaymentSchedule(RentModel $rent, int $leaseMonths): array
    {
        if ($leaseMonths < 1) {
            throw new AppException('Lease term must be at least 1 month');
        }

        if ($rent->first_pay_month === null) {
            throw new AppException('First pay month is required');
        }

        $paidAt = (int) $rent->paid_at;
        if ($paidAt < 1 || $paidAt > 31) {
            throw new AppException('Invalid pay date');
        }

        $amount = (string) $rent->amount;
        $base = Carbon::parse((string) $rent->first_pay_month)->startOfMonth();
        $items = [];

        for ($i = 0; $i < $leaseMonths; $i++) {
            $month = $base->copy()->addMonths($i);
            $lastDay = $month->copy()->endOfMonth()->day;
            $month->day(min($paidAt, $lastDay));
            $items[] = [
                'amount' => $amount,
                'last_paid_date' => $month->format('Y-m-d'),
            ];
        }

        return $items;
    }

    /**
     * App 端创建租金记录
     *
     * @param array<string, mixed> $params
     * @return array<string, mixed>
     */
    public function appCreate(int $userId, array $params): array
    {
        $amount = (float) ($params['amount'] ?? 0);
        if ($amount <= 0) {
            throw new AppException('Amount must be greater than 0');
        }

        $file = trim((string) ($params['file'] ?? ''));
        if ($file === '') {
            throw new AppException('Tenancy agreement is required');
        }

        $paidAt = $this->normalizePaidDay($params['paid_at'] ?? 0);
        $firstPayMonth = $this->normalizeFirstPayMonth(
            trim((string) ($params['first_pay_month'] ?? '')),
            $paidAt
        );

        $leaseMonths = (int) ($params['lease_months'] ?? 0);
        if ($leaseMonths < 1) {
            throw new AppException('Lease term must be at least 1 month');
        }

        $alreadyHasTenancy = RentModel::query()
            ->where('user_id', $userId)
            ->where('status', '!=', RentModel::STATUS_TERMINATED)
            ->exists();
        if ($alreadyHasTenancy) {
            throw new AppException('You already have a tenancy. Adding another home is coming soon.');
        }

        $rent = new RentModel();
        $rent->user_id = $userId;
        $rent->amount = $amount;
        $rent->file = $file;
        $rent->paid_at = $paidAt;
        $rent->first_pay_month = $firstPayMonth;
        $rent->lease_months = $leaseMonths;
        $rent->expire_date = $this->calculateExpireDate($leaseMonths);

        $propertyId = (int) ($params['property_id'] ?? 0);
        if ($propertyId > 0) {
            $property = LandlordPropertyModel::query()->find($propertyId);
            if (! $property) {
                throw new AppException('Property not found');
            }

            $landlord = LandlordModel::query()->find((int) $property->landlord_id);
            if (! $landlord) {
                throw new AppException('Landlord not found');
            }

            $this->applyLandlordBankDetailToRent($rent, $landlord);

            $rent->property_id = $propertyId;
            $rent->landlord_id = (int) $property->landlord_id;
            $rent->property_name = (string) $property->name;
            $rent->status = RentModel::STATUS_PENDING_BIND;
        } else {
            $propertyName = trim((string) ($params['property_name'] ?? ''));
            if ($propertyName === '') {
                throw new AppException('Property name is required');
            }
            $rent->property_name = $propertyName;
            $rent->status = RentModel::STATUS_PENDING;
            $rent->owner_name = trim((string) ($params['owner_name'] ?? ''));
            $rent->landlord_bank = trim((string) ($params['landlord_bank'] ?? ''));
            $rent->landlord_bank_account = trim((string) ($params['landlord_bank_account'] ?? ''));
            $rent->landlord_account_name = trim((string) ($params['landlord_account_name'] ?? ''));
        }

        $rent->save();

        return $this->formatAppItem($rent);
    }

    /**
     * App 端修改未审核通过的租约。
     *
     * @param array<string, mixed> $params
     * @return array<string, mixed>
     */
    public function appUpdate(int $userId, int $rentId, array $params): array
    {
        $rent = RentModel::query()
            ->where('id', $rentId)
            ->where('user_id', $userId)
            ->first();

        if (! $rent) {
            throw new AppException('Rent not found');
        }

        $status = (int) $rent->status;
        if (! in_array($status, [
            RentModel::STATUS_PENDING,
            RentModel::STATUS_REJECTED,
            RentModel::STATUS_PENDING_BIND,
        ], true)) {
            throw new AppException('Only a pending or rejected tenancy can be edited');
        }

        $paidAt = $this->normalizePaidDay($params['paid_at']);
        $submittedMonth = (string) $params['first_pay_month'];
        $storedDate = $rent->first_pay_month->format('Y-m-d');
        $firstPayMonth = $submittedMonth === substr($storedDate, 0, 7)
            ? $storedDate
            : $this->normalizeFirstPayMonth($submittedMonth, $paidAt);
        $leaseMonths = (int) $params['lease_months'];
        $propertyChanged = false;

        if ((int) $rent->property_id > 0) {
            $propertyId = (int) $params['property_id'];
            if ($propertyId !== (int) $rent->property_id) {
                $property = LandlordPropertyModel::query()->find($propertyId);
                if (! $property) {
                    throw new AppException('Property not found');
                }

                $landlord = LandlordModel::query()->find((int) $property->landlord_id);
                if (! $landlord) {
                    throw new AppException('Landlord not found');
                }

                $this->applyLandlordBankDetailToRent($rent, $landlord);
                $rent->property_id = $propertyId;
                $rent->landlord_id = (int) $property->landlord_id;
                $rent->property_name = (string) $property->name;
                $propertyChanged = true;
            }
        } else {
            $rent->property_name = trim((string) $params['property_name']);
            $rent->owner_name = trim((string) $params['owner_name']);
            $rent->landlord_bank = trim((string) $params['landlord_bank']);
            $rent->landlord_bank_account = trim((string) $params['landlord_bank_account']);
            $rent->landlord_account_name = trim((string) $params['landlord_account_name']);
        }

        $rent->amount = $params['amount'];
        $rent->file = (string) $params['file'];
        $rent->paid_at = $paidAt;
        $rent->first_pay_month = $firstPayMonth;
        $rent->lease_months = $leaseMonths;
        $rent->expire_date = $this->calculateExpireDate($leaseMonths, Carbon::parse((string) $rent->created_at));

        if ($propertyChanged) {
            $rent->status = RentModel::STATUS_PENDING_BIND;
        } elseif ($status === RentModel::STATUS_REJECTED) {
            $rent->status = $rent->rejected_by === RentModel::REJECTED_BY_OWNER
                ? RentModel::STATUS_PENDING_BIND
                : RentModel::STATUS_PENDING;
        }

        $rent->rejected_by = '';
        $rent->save();

        return $this->formatAppItem($rent);
    }

    /**
     * 未绑定房东的租约：保存租客填写的房东姓名、邮箱、手机号。
     *
     * @param array<string, mixed> $params
     * @return array<string, string>
     */
    public function appSaveOwnerContact(int $userId, int $rentId, array $params): array
    {
        $rent = RentModel::query()
            ->where('id', $rentId)
            ->where('user_id', $userId)
            ->first();

        if (! $rent) {
            throw new AppException('Rent not found');
        }

        $rent->owner_name = trim((string) ($params['owner_name'] ?? ''));
        $rent->owner_email = trim((string) ($params['owner_email'] ?? ''));
        $rent->owner_phone = trim((string) ($params['owner_phone'] ?? ''));
        $rent->save();

        return [
            'owner_name' => (string) $rent->owner_name,
            'owner_email' => (string) $rent->owner_email,
            'owner_phone' => (string) $rent->owner_phone,
        ];
    }

    /**
     * App 端：通过物业 sn 查询房产
     *
     * @return array<string, mixed>
     */
    public function appPropertyBySn(string $sn): array
    {
        $sn = trim($sn);
        if ($sn === '') {
            throw new AppException('Property serial number is required');
        }

        $property = LandlordPropertyModel::query()
            ->where('sn', $sn)
            ->with(['landlord:id,name'])
            ->first();

        if (! $property) {
            throw new AppException('Property not found');
        }

        return [
            'id' => (int) $property->id,
            'name' => (string) $property->name,
            'landlord_name' => trim((string) ($property->landlord?->name ?? '')),
        ];
    }

    /**
     * 房产下拉（审核用）
     */
    public function propertyOptions(): array
    {
        return LandlordPropertyModel::query()
            ->with(['landlord:id,name'])
            ->orderBy('id', 'asc')
            ->get()
            ->map(function (LandlordPropertyModel $property) {
                $data = [
                    'id' => $property->id,
                    'name' => $property->name,
                    'landlord_id' => $property->landlord_id,
                    'landlord_name' => $property->landlord?->name ?? '',
                ];

                return $data;
            })
            ->all();
    }

    /**
     * @param list<int> $rentIds
     * @return list<int>
     */
    private function resolvePayableRentIds(array $rentIds): array
    {
        $rentIds = array_values(array_filter(array_map('intval', $rentIds)));
        if ($rentIds === []) {
            return [];
        }

        $query = RentHistoryModel::query()->whereIn('rent_id', $rentIds);
        $this->historyService->applyPayablePendingScope($query);

        return $query
            ->distinct()
            ->pluck('rent_id')
            ->map(fn ($id) => (int) $id)
            ->all();
    }

    /**
     * @return array<string, mixed>
     */
    private function formatAppListItem(
        RentModel $rent,
        float $multiplier,
        bool $hasPayablePending = false,
        ?string $nextPayableDueDate = null,
    ): array {
        $landlord = $rent->landlord;
        $landlordId = $rent->landlord_id ? (int) $rent->landlord_id : null;
        $landlordName = trim((string) ($landlord?->name ?? ''));
        if ($landlordName === '') {
            $landlordName = trim((string) ($rent->owner_name ?? ''));
        }
        if ($landlordName === '') {
            $landlordName = trim((string) ($rent->landlord_account_name ?? ''));
        }
        $amount = (float) $rent->amount;
        $file = (string) $rent->file;
        $dueLabels = $this->historyService->formatRentDueLabels(
            $nextPayableDueDate,
            (string) ($rent->created_at ?? '')
        );
        $propertyImage = (string) ($rent->property?->image ?? '');

        return [
            'id' => $rent->id,
            'amount' => $rent->amount,
            'file' => $file,
            'file_url' => file_url($file),
            'paid_at' => $rent->paid_at,
            'first_pay_month' => $rent->first_pay_month?->format('Y-m') ?? '',
            'lease_months' => (int) ($rent->lease_months ?? 0),
            'expire_date' => $rent->expire_date?->format('Y-m-d') ?? '',
            'status' => $rent->status,
            'property_id' => $rent->property_id ? (int) $rent->property_id : null,
            'landlord_id' => $landlordId,
            'landlord_name' => $landlordName,
            'owner_name' => (string) ($rent->owner_name ?? ''),
            'landlord_bank' => (string) ($rent->landlord_bank ?? ''),
            'landlord_bank_account' => (string) ($rent->landlord_bank_account ?? ''),
            'landlord_account_name' => (string) ($rent->landlord_account_name ?? ''),
            'owner_email' => (string) ($rent->owner_email ?? ''),
            'owner_phone' => (string) ($rent->owner_phone ?? ''),
            'owner_linked' => $landlordId !== null,
            'property_name' => $this->resolvePropertyName($rent),
            'property_image' => file_url($propertyImage),
            'earn_points' => (int) round($amount * $multiplier),
            'created_at' => $rent->created_at?->format('Y-m-d H:i:s') ?? '',
            'can_pay' => (int) $rent->status === RentModel::STATUS_APPROVED && $hasPayablePending,
            'due_status' => $dueLabels['due_status'],
            'date_label' => $dueLabels['date_label'],
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatAppItem(RentModel $rent): array
    {
        return [
            'id' => $rent->id,
            'amount' => $rent->amount,
            'file' => $rent->file,
            'paid_at' => $rent->paid_at,
            'first_pay_month' => $rent->first_pay_month?->format('Y-m') ?? '',
            'lease_months' => (int) ($rent->lease_months ?? 0),
            'expire_date' => $rent->expire_date?->format('Y-m-d') ?? '',
            'status' => $rent->status,
            'created_at' => $rent->created_at?->format('Y-m-d H:i:s') ?? '',
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatListItem(RentModel $rent): array
    {
        $data = $rent->toArray();
        unset($data['user'], $data['landlord']);

        $user = $rent->user;
        $landlord = $rent->landlord;

        $data['user_account'] = $user?->account ?? '';
        $data['user_name'] = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));
        $data['landlord_name'] = trim((string) ($landlord?->name ?? ''));
        if ($data['landlord_name'] === '') {
            $data['landlord_name'] = trim((string) ($rent->owner_name ?? ''));
        }

        $file = (string) ($rent->file ?? '');
        $data['file'] = $file;
        $data['file_url'] = file_url($file);
        $data['first_pay_month'] = $rent->first_pay_month?->format('Y-m') ?? '';
        $data['property_name'] = $this->resolvePropertyName($rent);
        $data['property_address'] = $rent->property?->address ?? '';
        $data['landlord_bank'] = trim((string) ($rent->landlord_bank ?? ''));
        $data['landlord_bank_account'] = trim((string) ($rent->landlord_bank_account ?? ''));
        $data['landlord_account_name'] = trim((string) ($rent->landlord_account_name ?? ''));
        $data['terminated_at'] = $rent->terminated_at?->format('Y-m-d H:i:s') ?? '';
        $data['terminate_reason'] = (string) ($rent->terminate_reason ?? '');

        return $data;
    }

    private function findOrFail(int $id): RentModel
    {
        $rent = RentModel::query()->find($id);
        if (! $rent) {
            throw new AppException('Rent record not found');
        }

        return $rent;
    }

    private function applyLandlordBankDetailToRent(RentModel $rent, LandlordModel $landlord): void
    {
        $bankName = trim((string) ($landlord->bank_name ?? ''));
        $bankAccount = trim((string) ($landlord->bank_account ?? ''));
        $accountHolderName = trim((string) ($landlord->account_holder_name ?? ''));

        if ($bankAccount === '') {
            throw new AppException('Landlord bank details are incomplete');
        }

        $rent->landlord_bank = $bankName;
        $rent->landlord_bank_account = $bankAccount;
        $rent->landlord_account_name = $accountHolderName;
    }

    private function resolvePropertyName(RentModel $rent): string
    {
        $stored = trim((string) ($rent->property_name ?? ''));
        if ($stored !== '') {
            return $stored;
        }

        return trim((string) ($rent->property?->name ?? ''));
    }

    /**
     * @return array<string, mixed>
     */
    private function formatLandlordDetailItem(RentModel $rent): array
    {
        $user = $rent->user;
        $property = $rent->property;
        $userName = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));
        $propertyName = $this->resolvePropertyName($rent);
        $propertyAddress = trim((string) ($property?->address ?? ''));
        $status = (int) $rent->status;
        $amount = number_format((float) $rent->amount, 2, '.', '');

        return [
            'id' => (int) $rent->id,
            'tenant_name' => $userName,
            'tenant_initials' => $this->resolveTenantInitials($userName),
            'tenant_avatar' => file_url((string) ($user?->avatar ?? '')),
            'property_name' => $propertyName,
            'property_address' => $propertyAddress,
            'amount' => $amount,
            'paid_at' => (int) ($rent->paid_at ?? 0),
            'first_pay_month' => $rent->first_pay_month?->format('Y-m') ?? '',
            'lease_months' => (int) ($rent->lease_months ?? 0),
            'expire_date' => $rent->expire_date?->format('Y-m-d') ?? '',
            'created_at' => $rent->created_at?->format('Y-m-d H:i:s') ?? '',
            'file_url' => file_url((string) ($rent->file ?? '')),
            'status' => $status,
            'can_terminate' => in_array(
                $status,
                [RentModel::STATUS_APPROVED, RentModel::STATUS_PENDING_BIND],
                true
            ),
        ];
    }

    private function resolveTenantInitials(string $name): string
    {
        $name = trim($name);
        if ($name === '') {
            return '?';
        }

        return mb_strtoupper(mb_substr($name, 0, 1));
    }

    private function normalizePaidDay(mixed $value): int
    {
        $day = (int) $value;
        if ($day < 1 || $day > 31) {
            throw new AppException('Paid day must be between 1 and 31');
        }

        return $day;
    }

    private function normalizeFirstPayMonth(string $value, int $paidAt): string
    {
        if ($value === '' || ! preg_match('/^\d{4}-\d{2}$/', $value)) {
            throw new AppException('Invalid first pay month');
        }

        [$year, $month] = array_map('intval', explode('-', $value));
        if ($month < 1 || $month > 12) {
            throw new AppException('Invalid first pay month');
        }

        $today = Carbon::now();
        $currentMonth = $today->copy()->startOfMonth();
        $nextMonth = $currentMonth->copy()->addMonth();
        $target = Carbon::create($year, $month, 1)->startOfMonth();

        if ($paidAt > $today->day) {
            $allowed = [$currentMonth->format('Y-m'), $nextMonth->format('Y-m')];
        } else {
            $allowed = [$nextMonth->format('Y-m')];
        }

        if (! in_array($target->format('Y-m'), $allowed, true)) {
            throw new AppException('Invalid first pay month for the selected pay date');
        }

        return $target->format('Y-m-d');
    }

    private function calculateExpireDate(int $leaseMonths, ?Carbon $createdAt = null): string
    {
        $created = ($createdAt ?? Carbon::now())->copy()->startOfDay();
        $day = $created->day;
        $target = $created->copy()->startOfMonth()->addMonths($leaseMonths);
        $lastDay = $target->copy()->endOfMonth()->day;
        $target->day(min($day, $lastDay));

        return $target->format('Y-m-d');
    }
}
