<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\RentHistoryModel;
use App\Model\RentModel;
use Hyperf\Context\Context;
use Hyperf\HttpServer\Contract\RequestInterface;

class RentHistoryService
{
    /**
     * App 端还款历史列表
     */
    public function appList(int $userId, int $page, int $limit, ?int $year = null, ?int $rentId = null): array
    {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 15;

        $query = RentHistoryModel::query()
            ->with([
                'rent:id,amount,landlord_account_name,property_id,property_name',
                'rent.property:id,name,address',
            ])
            ->where('user_id', $userId)
            ->where('status', '!=', RentHistoryModel::STATUS_CANCELLED)
            ->whereHas('rent');

        if ($rentId !== null && $rentId > 0) {
            $query->where('rent_id', $rentId);
        }

        if ($year !== null && $year > 0) {
            $query->whereBetween('last_paid_date', [
                sprintf('%04d-01-01', $year),
                sprintf('%04d-12-31', $year),
            ]);
        }

        // 列表页（Recent Payments / History）仅展示已付款与逾期；详情页传 rent_id 时返回全部。
        if ($rentId === null || $rentId <= 0) {
            $this->applyPaidOrOverdueFilter($query);
        }

        $total = (clone $query)->count();

        if ($rentId !== null && $rentId > 0) {
            $query->orderBy('last_paid_date', 'asc');
        } else {
            $query->orderByDesc('last_paid_date','desc');
        }

        $items = $query
            ->forPage($page, $limit)
            ->get()
            ->map(function (RentHistoryModel $history) {
                return $this->formatAppListItem($history);
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
     * 还款结算列表
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
        $startDate = trim((string) $request->input('start_date', ''));
        $endDate = trim((string) $request->input('end_date', ''));

        $query = RentHistoryModel::query()
            ->with([
                'user:id,account,first_name,last_name',
                'rent:id,amount,landlord_bank,landlord_bank_account,landlord_account_name',
                'settledAdmin:id,real_name',
            ])
            ->whereHas('rent');

        if ($status !== null && $status !== '') {
            $this->applyStatusFilter($query, $status);
        }

        if ($userAccount !== '') {
            $query->whereHas('user', function ($userQuery) use ($userAccount) {
                $userQuery->where('account', 'like', "%{$userAccount}%");
            });
        }

        if ($landlordName !== '') {
            $query->whereHas('rent.landlord', function ($landlordQuery) use ($landlordName) {
                $landlordQuery->where('name', 'like', "%{$landlordName}%");
            });
        }

        if ($landlordBankAccount !== '') {
            $query->whereHas('rent', function ($rentQuery) use ($landlordBankAccount) {
                $rentQuery->where('landlord_bank_account', 'like', "%{$landlordBankAccount}%");
            });
        }

        if ($startDate !== '') {
            $query->where('last_paid_date', '>=', $this->normalizeDate($startDate));
        }

        if ($endDate !== '') {
            $query->where('last_paid_date', '<=', $this->normalizeDate($endDate));
        }

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (RentHistoryModel $history) {
                return $this->formatListItem($history);
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
     * 审核通过时批量创建还款计划
     *
     * @param array<int, array{amount: string, last_paid_date: string}> $scheduleItems
     */
    public function createBatchForRentAudit(RentModel $rent, array $scheduleItems): void
    {
        foreach ($scheduleItems as $item) {
            $history = new RentHistoryModel();
            $history->rent_id = (int) $rent->id;
            $history->user_id = (int) $rent->user_id;
            $history->amount = (string) ($item['amount'] ?? $rent->amount);
            $history->last_paid_date = (string) ($item['last_paid_date'] ?? '');
            $history->status = RentHistoryModel::STATUS_PENDING;
            $history->save();
        }
    }

    /**
     * 平台结算
     */
    public function settle(int $id, string $receipt): void
    {
        $history = $this->findOrFail($id);
        if ((int) $history->status !== RentHistoryModel::STATUS_PAID) {
            throw new AppException('Only paid records can be settled');
        }

        $receipt = trim($receipt);
        if ($receipt === '') {
            throw new AppException('Receipt is required');
        }

        $adminId = (int) (Context::get('auth')?->id ?? 0);
        if ($adminId <= 0) {
            throw new AppException('Admin not found');
        }

        $history->loadMissing('rent');
        if ((float) $history->amount <= 0 && $history->rent !== null) {
            $history->amount = $history->rent->amount;
        }

        $history->receipt = $receipt;
        $history->status = RentHistoryModel::STATUS_SETTLED;
        $history->platform_settled_at = date('Y-m-d H:i:s');
        $history->settled_by = $adminId;
        $history->save();
    }

    /**
     * 房东端：已结算收款记录列表
     */
    public function landlordSettledList(int $landlordId, RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;
        $year = (int) $request->input('year', (int) date('Y'));
        $month = (int) $request->input('month', (int) date('n'));

        if ($year <= 0) {
            $year = (int) date('Y');
        }
        if ($month < 1 || $month > 12) {
            $month = (int) date('n');
        }

        [$monthStart, $monthEnd] = $this->resolveMonthRange($year, $month);

        $query = RentHistoryModel::query()
            ->with(['user:id,first_name,last_name,avatar'])
            ->where('status', RentHistoryModel::STATUS_SETTLED)
            ->whereBetween('created_at', [$monthStart, $monthEnd])
            ->whereHas('rent', function ($rentQuery) use ($landlordId) {
                $rentQuery->where('landlord_id', $landlordId);
            });

        $total = (clone $query)->count();
        $amountSum = number_format((float) (clone $query)->sum('amount'), 2, '.', '');

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (RentHistoryModel $history) {
                return $this->formatLandlordRecordItem($history);
            })
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'amount_sum' => $amountSum,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * @return array{0: string, 1: string}
     */
    private function resolveMonthRange(int $year, int $month): array
    {
        $monthStart = sprintf('%04d-%02d-01 00:00:00', $year, $month);
        $lastDay = (int) date('t', strtotime($monthStart));
        $monthEnd = sprintf('%04d-%02d-%02d 23:59:59', $year, $month, $lastDay);

        return [$monthStart, $monthEnd];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatLandlordRecordItem(RentHistoryModel $history): array
    {
        $user = $history->user;
        $userName = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));

        return [
            'id' => (int) $history->id,
            'amount' => $this->resolveHistoryAmount($history),
            'created_at' => $this->formatDateTime($history->created_at),
            'user_name' => $userName,
            'initials' => $this->resolveInitials($userName),
            'avatar' => file_url((string) ($user?->avatar ?? '')),
        ];
    }

    private function formatDateTime(mixed $value): string
    {
        if ($value === null || $value === '') {
            return '';
        }

        if ($value instanceof \DateTimeInterface) {
            return $value->format('Y-m-d H:i:s');
        }

        $timestamp = strtotime((string) $value);

        return $timestamp !== false ? date('Y-m-d H:i:s', $timestamp) : (string) $value;
    }

    private function resolveHistoryAmount(RentHistoryModel $history): string
    {
        $amount = (string) ($history->amount ?? '');
        if ($amount !== '' && (float) $amount > 0) {
            return number_format((float) $amount, 2, '.', '');
        }

        $history->loadMissing('rent');
        $rentAmount = (string) ($history->rent?->amount ?? '0');

        return number_format((float) $rentAmount, 2, '.', '');
    }

    private function resolveInitials(string $name): string
    {
        $name = trim($name);
        if ($name === '') {
            return '?';
        }

        return mb_strtoupper(mb_substr($name, 0, 1));
    }

    /**
     * @return array<string, mixed>
     */
    public function formatAppListItem(RentHistoryModel $history): array
    {
        $data = $history->toArray();
        unset($data['rent']);

        $rent = $history->rent;
        $property = $rent?->property;

        $data['amount'] = $this->resolveHistoryAmount($history);
        $data['landlord_account_name'] = $rent?->landlord_account_name ?? '';
        $data['property_address'] = $this->resolvePropertyAddress(
            $property,
            trim((string) ($rent?->property_name ?? '')),
            $rent?->landlord_account_name ?? ''
        );
        $data['pay_status'] = $this->resolvePayStatus($data);
        // App 列表仅区分按时 / 逾期，与 pay_status 保持一致。
        $data['display_status'] = $data['pay_status'];
        $data['payment_method'] = (string) ($history->payment_method ?? '');
        $data['payment_no'] = $this->formatPaymentNo((int) $history->id);
        $data['rental_period'] = $this->formatRentalPeriod((string) ($history->last_paid_date ?? ''));

        return $data;
    }

    private function formatPaymentNo(int $id): string
    {
        return 'INV-' . str_pad((string) $id, 7, '0', STR_PAD_LEFT);
    }

    private function formatRentalPeriod(string $lastPaidDate): string
    {
        $date = $this->extractDateOnly($lastPaidDate);
        if ($date === '') {
            return '';
        }

        $timestamp = strtotime($date);
        if ($timestamp === false) {
            return '';
        }

        return date('F Y', $timestamp);
    }

    private function resolvePropertyAddress(?object $property, string $storedName, string $fallback): string
    {
        if ($property !== null) {
            $address = trim((string) ($property->address ?? ''));
            if ($address !== '') {
                return $address;
            }

            $name = trim((string) ($property->name ?? ''));
            if ($name !== '') {
                return $name;
            }
        }

        if ($storedName !== '') {
            return $storedName;
        }

        return trim($fallback);
    }

    /**
     * @return array<string, mixed>
     */
    private function formatListItem(RentHistoryModel $history): array
    {
        $data = $history->toArray();
        unset($data['user'], $data['rent'], $data['settled_admin']);

        $user = $history->user;
        $rent = $history->rent;
        $admin = $history->settledAdmin;

        $data['user_account'] = $user?->account ?? '';
        $data['user_name'] = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));
        $data['amount'] = $this->resolveHistoryAmount($history);
        $data['landlord_bank'] = $rent?->landlord_bank ?? '';
        $data['landlord_bank_account'] = $rent?->landlord_bank_account ?? '';
        $data['landlord_account_name'] = $rent?->landlord_account_name ?? '';
        $data['settled_by_name'] = $admin?->real_name ?? '';
        $data['display_status'] = $this->resolveDisplayStatus($data);

        return $data;
    }

    /**
     * @param array<string, mixed> $row
     */
    private function resolveDisplayStatus(array $row): string
    {
        $status = (int) ($row['status'] ?? 0);
        if ($status === RentHistoryModel::STATUS_PENDING) {
            $lastPaidDate = (string) ($row['last_paid_date'] ?? '');
            if ($lastPaidDate !== '' && date('Y-m-d') > $lastPaidDate) {
                return 'overdue';
            }

            return 'pending';
        }

        if ($status === RentHistoryModel::STATUS_PAID) {
            return 'paid';
        }

        if ($status === RentHistoryModel::STATUS_CANCELLED) {
            return 'cancelled';
        }

        return 'settled';
    }

    /**
     * App Property Journey 支付状态：on_time / late / upcoming
     *
     * @param array<string, mixed> $row
     */
    public function resolvePayStatus(array $row): string
    {
        $status = (int) ($row['status'] ?? 0);
        $lastPaidDate = $this->extractDateOnly((string) ($row['last_paid_date'] ?? ''));
        $today = date('Y-m-d');

        if ($status === RentHistoryModel::STATUS_PAID || $status === RentHistoryModel::STATUS_SETTLED) {
            $userPaidAt = $this->extractDateOnly((string) ($row['user_paid_at'] ?? ''));
            $openedAt = $this->extractDateOnly((string) ($row['created_at'] ?? ''));
            $paidAfterDue = $lastPaidDate !== '' && $userPaidAt !== '' && $userPaidAt > $lastPaidDate;
            // A backdated installment paid the day it was opened could not have been paid by its due date.
            $paidWhenOpened = $paidAfterDue
                && $openedAt !== ''
                && $userPaidAt === $openedAt
                && $openedAt > $lastPaidDate;
            if ($paidAfterDue && ! $paidWhenOpened) {
                return 'late';
            }

            return 'on_time';
        }

        if ($lastPaidDate !== '' && $today > $lastPaidDate) {
            return 'late';
        }

        return 'upcoming';
    }

    /**
     * 可支付待还：任意未付期，含未到到期月的下一期。
     *
     * @param \Hyperf\Database\Model\Builder $query
     */
    public function applyPayablePendingScope($query): void
    {
        $query->where('status', RentHistoryModel::STATUS_PENDING);
    }

    /**
     * 用户全部可支付待还记录中 last_paid_date 最早的一条。
     */
    public function findEarliestPayablePending(int $userId): ?RentHistoryModel
    {
        if ($userId <= 0) {
            return null;
        }

        $query = RentHistoryModel::query()
            ->where('user_id', $userId)
            ->with(['rent.landlord:id,name', 'rent.property:id,name,image'])
            ->whereHas('rent', function ($rentQuery) {
                $rentQuery->where('status', RentModel::STATUS_APPROVED);
            });
        $this->applyPayablePendingScope($query);

        $history = $query
            ->orderBy('last_paid_date')
            ->orderBy('id')
            ->first();

        if (! $history || ! $history->rent) {
            return null;
        }

        return $history;
    }

    /**
     * @param list<int> $rentIds
     * @return array<int, string> rent_id => last_paid_date (Y-m-d)
     */
    public function resolveNextPayableDueDatesByRentIds(array $rentIds): array
    {
        $rentIds = array_values(array_filter(array_map('intval', $rentIds)));
        if ($rentIds === []) {
            return [];
        }

        $query = RentHistoryModel::query()
            ->selectRaw('rent_id, MIN(last_paid_date) as last_paid_date')
            ->whereIn('rent_id', $rentIds);
        $this->applyPayablePendingScope($query);

        $result = [];
        foreach ($query->groupBy('rent_id')->get() as $row) {
            $date = $this->extractDateOnly((string) ($row->last_paid_date ?? ''));
            if ($date === '') {
                continue;
            }
            $result[(int) $row->rent_id] = $date;
        }

        return $result;
    }

    /**
     * @return array{due_status: string, date_label: string}
     */
    public function formatRentDueLabels(?string $lastPaidDate, ?string $tenancyCreatedAt): array
    {
        $dueDate = $this->extractDateOnly((string) $lastPaidDate);
        if ($dueDate === '') {
            return [
                'due_status' => '',
                'date_label' => '',
            ];
        }

        $days = (int) floor((strtotime($dueDate) - strtotime(date('Y-m-d'))) / 86400);
        $createdDate = $this->extractDateOnly((string) $tenancyCreatedAt);
        $dateLabel = $this->formatEnglishDateLabel($dueDate);

        if ($days === 0) {
            $dueStatus = 'due_today';
        } elseif ($days > 0 || $dueDate < $createdDate) {
            $dueStatus = 'advance';
        } else {
            $dueStatus = 'overdue';
        }

        return [
            'due_status' => $dueStatus,
            'date_label' => $dateLabel,
        ];
    }

    private function formatEnglishDateLabel(string $date): string
    {
        $months = [
            1 => 'Jan',
            2 => 'Feb',
            3 => 'Mar',
            4 => 'Apr',
            5 => 'May',
            6 => 'Jun',
            7 => 'Jul',
            8 => 'Aug',
            9 => 'Sep',
            10 => 'Oct',
            11 => 'Nov',
            12 => 'Dec',
        ];

        $parts = explode('-', $date);
        if (count($parts) !== 3) {
            return '';
        }

        $year = (int) $parts[0];
        $month = (int) $parts[1];
        $day = (int) $parts[2];
        if ($year <= 0 || $month < 1 || $month > 12 || $day <= 0) {
            return '';
        }

        return $day . ' ' . $months[$month] . ' ' . $year;
    }

    public function extractDateOnly(string $value): string
    {
        $value = trim($value);
        if ($value === '') {
            return '';
        }

        if (preg_match('/^\d{4}-\d{2}-\d{2}/', $value, $matches)) {
            return $matches[0];
        }

        return '';
    }

    /**
     * App 列表：已付款 / 已结算，或待还款且已逾期（排除未到支付时间）。
     *
     * @param \Hyperf\Database\Model\Builder $query
     */
    private function applyPaidOrOverdueFilter($query): void
    {
        $today = date('Y-m-d');

        $query->where(function ($builder) use ($today) {
            $builder->whereIn('status', [
                RentHistoryModel::STATUS_PAID,
                RentHistoryModel::STATUS_SETTLED,
            ])->orWhere(function ($pendingQuery) use ($today) {
                $pendingQuery->where('status', RentHistoryModel::STATUS_PENDING)
                    ->where('last_paid_date', '<', $today);
            });
        });
    }

    /**
     * @param \Hyperf\Database\Model\Builder $query
     */
    private function applyStatusFilter($query, mixed $status): void
    {
        if ((string) $status === 'overdue') {
            $query->where('status', RentHistoryModel::STATUS_PENDING)
                ->where('last_paid_date', '<', date('Y-m-d'));

            return;
        }

        $storedStatus = (int) $status;
        if ($storedStatus === RentHistoryModel::STATUS_PENDING) {
            $query->where('status', RentHistoryModel::STATUS_PENDING)
                ->where('last_paid_date', '>=', date('Y-m-d'));

            return;
        }

        if ($storedStatus === RentHistoryModel::STATUS_CANCELLED) {
            $query->where('status', RentHistoryModel::STATUS_CANCELLED);

            return;
        }

        $query->where('status', $storedStatus);
    }

    private function findOrFail(int $id): RentHistoryModel
    {
        $history = RentHistoryModel::query()->find($id);
        if (! $history) {
            throw new AppException('Rent history not found');
        }

        return $history;
    }

    private function normalizeDate(string $value): string
    {
        $date = trim($value);
        if (! preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
            throw new AppException('Invalid date format');
        }

        return $date;
    }
}
