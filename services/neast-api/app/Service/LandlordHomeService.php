<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\LandlordPropertyModel;
use App\Model\RentHistoryModel;
use App\Model\RentModel;
use Hyperf\Di\Annotation\Inject;

class LandlordHomeService
{
    #[Inject]
    protected MessageService $messageService;
    /**
     * 房东端首页聚合数据
     *
     * @return array<string, mixed>
     */
    public function dashboard(int $landlordId): array
    {
        $today = date('Y-m-d');
        $dueSoonEnd = date('Y-m-d', strtotime($today . ' +7 days'));
        $year = (int) date('Y');
        $month = (int) date('n');
        [$monthStart, $monthEnd] = $this->resolveMonthRange($year, $month);

        $landlordScope = function ($query) use ($landlordId) {
            $query->where('status', '!=', RentHistoryModel::STATUS_CANCELLED)
                ->whereHas('rent', function ($rentQuery) use ($landlordId) {
                    $rentQuery->where('landlord_id', $landlordId)
                        ->where('status', '!=', RentModel::STATUS_TERMINATED);
                });
        };

        $baseMonthQuery = RentHistoryModel::query()
            ->whereBetween('created_at', [$monthStart, $monthEnd])
            ->where($landlordScope);

        $monthTotal = (clone $baseMonthQuery)->count();
        $monthPendingCount = (clone $baseMonthQuery)
            ->where('status', RentHistoryModel::STATUS_PENDING)
            ->count();
        $collected = number_format((float) (clone $baseMonthQuery)->sum('amount'), 2, '.', '');
        $overdueAmount = number_format(
            (float) (clone $baseMonthQuery)
                ->where('status', RentHistoryModel::STATUS_PENDING)
                ->where('last_paid_date', '<', $today)
                ->sum('amount'),
            2,
            '.',
            ''
        );
        $collectionRate = $monthTotal > 0
            ? (int) round((($monthTotal - $monthPendingCount) / $monthTotal) * 100)
            : 0;

        $baseAllQuery = RentHistoryModel::query()->where($landlordScope);

        $overdueCount = (clone $baseAllQuery)
            ->where('status', RentHistoryModel::STATUS_PENDING)
            ->where('last_paid_date', '<', $today)
            ->count();

        $dueSoonCount = (clone $baseAllQuery)
            ->where('status', RentHistoryModel::STATUS_PENDING)
            ->whereBetween('last_paid_date', [$today, $dueSoonEnd])
            ->count();

        $needAckItems = $this->needAckList($landlordId);
        $needAckCount = count($needAckItems);

        $withRelations = $this->ackWithRelations();

        $overdueList = (clone $baseAllQuery)
            ->with($withRelations)
            ->where('status', RentHistoryModel::STATUS_PENDING)
            ->where('last_paid_date', '<', $today)
            ->orderBy('last_paid_date')
            ->get()
            ->map(fn (RentHistoryModel $history) => $this->formatRentItem($history, 'overdue'))
            ->all();

        $dueSoonList = (clone $baseAllQuery)
            ->with($withRelations)
            ->where('status', RentHistoryModel::STATUS_PENDING)
            ->whereBetween('last_paid_date', [$today, $dueSoonEnd])
            ->orderBy('last_paid_date')
            ->get()
            ->map(fn (RentHistoryModel $history) => $this->formatRentItem($history, 'due_soon'))
            ->all();

        $needAckHistory = $needAckItems[0] ?? null;

        $propertyCount = LandlordPropertyModel::query()
            ->where('landlord_id', $landlordId)
            ->count();

        $tenantCount = RentModel::query()
            ->where('landlord_id', $landlordId)
            ->activeApproved()
            ->count();

        return [
            'has_unread_message' => $this->messageService->landlordHasUnread($landlordId),
            'header' => [
                'collected' => $collected,
                'collection_rate' => $collectionRate,
                'overdue_amount' => $overdueAmount,
            ],
            'need_action' => [
                'overdue' => $overdueCount,
                'due_soon' => $dueSoonCount,
                'need_ack' => $needAckCount,
            ],
            'overdue_list' => $overdueList,
            'due_soon_list' => $dueSoonList,
            'need_ack' => $needAckHistory,
            'portfolio' => [
                'properties' => $propertyCount,
                'tenants' => $tenantCount,
                'rent_roll' => $collected,
            ],
        ];
    }

    /**
     * 房东端：待确认收款列表（全量，不分页）
     *
     * @return list<array<string, mixed>>
     */
    public function needAckList(int $landlordId): array
    {
        return RentHistoryModel::query()
            ->with($this->ackWithRelations())
            ->whereHas('rent', function ($rentQuery) use ($landlordId) {
                $rentQuery->where('landlord_id', $landlordId);
            })
            ->where('status', RentHistoryModel::STATUS_SETTLED)
            ->where('is_confirm', 0)
            ->orderByDesc('id')
            ->get()
            ->map(fn (RentHistoryModel $history) => $this->formatAckItem($history))
            ->all();
    }

    /**
     * 房东确认收款：is_confirm=1，写入 confirm_at
     */
    public function confirmAck(int $landlordId, int $id): void
    {
        $history = RentHistoryModel::query()
            ->where('id', $id)
            ->whereHas('rent', function ($rentQuery) use ($landlordId) {
                $rentQuery->where('landlord_id', $landlordId);
            })
            ->first();

        if ($history === null) {
            throw new AppException('Record not found');
        }

        if ((int) $history->status !== RentHistoryModel::STATUS_SETTLED) {
            throw new AppException('Record cannot be confirmed');
        }

        if ((int) $history->is_confirm === 1) {
            throw new AppException('Already confirmed');
        }

        $history->is_confirm = 1;
        $history->confirm_at = date('Y-m-d H:i:s');
        $history->save();
    }

    /**
     * @return list<string>
     */
    private function ackWithRelations(): array
    {
        return [
            'user:id,first_name,last_name,avatar',
            'rent:id,amount,property_id,landlord_account_name,file',
            'rent.property:id,name,address',
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
    private function formatRentItem(RentHistoryModel $history, string $status): array
    {
        $user = $history->user;
        $rent = $history->rent;
        $property = $rent?->property;
        $userName = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));
        $lastPaidDate = (string) ($history->last_paid_date ?? '');
        $today = date('Y-m-d');

        if ($status === 'overdue') {
            $daysLate = max(1, (int) ((strtotime($today) - strtotime($lastPaidDate)) / 86400));
            $statusText = $daysLate === 1 ? '1 Day late' : "{$daysLate} Days late";
        } else {
            $daysUntil = max(0, (int) ((strtotime($lastPaidDate) - strtotime($today)) / 86400));
            $statusText = $daysUntil <= 0 ? 'Due today' : "In {$daysUntil}D";
        }

        $propertyName = trim((string) ($property?->name ?? ''));
        $propertyAddress = trim((string) ($property?->address ?? ''));
        if ($propertyAddress === '') {
            $propertyAddress = trim((string) ($rent?->landlord_account_name ?? ''));
        }

        $unitAddress = $propertyName !== '' ? $propertyName : $propertyAddress;
        $amount = $this->resolveHistoryAmount($history);

        return [
            'id' => (int) $history->id,
            'tenant_initials' => $this->resolveInitials($userName),
            'tenant_name' => $userName,
            'unit_address' => $unitAddress,
            'status_text' => $statusText,
            'amount' => $this->formatDisplayAmount($amount),
            'property_name' => $propertyName,
            'property_address' => $propertyAddress,
            'rental_date' => $this->formatEnglishDate($lastPaidDate),
            'status' => $status,
            'file_url' => file_url((string) ($rent?->file ?? '')),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatAckItem(RentHistoryModel $history): array
    {
        $user = $history->user;
        $rent = $history->rent;
        $property = $rent?->property;
        $userName = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));
        $amount = $this->resolveHistoryAmount($history);
        $paidAt = $history->user_paid_at ?? $history->platform_settled_at;
        $paidDate = $this->formatEnglishDate($paidAt);
        $propertyName = trim((string) ($property?->name ?? ''));
        $propertyAddress = trim((string) ($property?->address ?? ''));

        return [
            'id' => (int) $history->id,
            'initials' => $this->resolveInitials($userName),
            'name' => $userName,
            'amount' => $this->formatDisplayAmount($amount),
            'paid_text' => $paidDate !== '' ? "Paid on {$paidDate}" : 'Paid',
            'paid_date' => $paidDate,
            'property_name' => $propertyName,
            'property_address' => $propertyAddress,
            'rental_date' => $this->formatEnglishDate((string) ($history->last_paid_date ?? '')),
            'file_url' => file_url((string) ($rent?->file ?? '')),
        ];
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

    private function formatDisplayAmount(string $amount): string
    {
        return number_format((float) $amount, 0, '.', ',');
    }

    private function resolveInitials(string $name): string
    {
        $name = trim($name);
        if ($name === '') {
            return '?';
        }

        return mb_strtoupper(mb_substr($name, 0, 1));
    }

    private function formatEnglishDate(mixed $value): string
    {
        if ($value === null || $value === '') {
            return '';
        }

        $timestamp = $value instanceof \DateTimeInterface
            ? $value->getTimestamp()
            : strtotime((string) $value);

        if ($timestamp === false) {
            return '';
        }

        return date('j F Y', $timestamp);
    }
}
