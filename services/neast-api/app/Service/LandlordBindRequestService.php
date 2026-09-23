<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\RentModel;

class LandlordBindRequestService
{
    /**
     * 待绑定列表（全量，不分页）
     *
     * @return list<array<string, mixed>>
     */
    public function list(int $landlordId): array
    {
        return RentModel::query()
            ->with($this->withRelations())
            ->where('landlord_id', $landlordId)
            ->where('status', RentModel::STATUS_PENDING_BIND)
            ->orderByDesc('id')
            ->get()
            ->map(fn (RentModel $rent) => $this->formatItem($rent))
            ->all();
    }

    public function count(int $landlordId): int
    {
        return RentModel::query()
            ->where('landlord_id', $landlordId)
            ->where('status', RentModel::STATUS_PENDING_BIND)
            ->count();
    }

    /**
     * 首页展示的第一条待绑定申请
     *
     * @return array<string, mixed>|null
     */
    public function first(int $landlordId): ?array
    {
        $items = $this->list($landlordId);

        return $items[0] ?? null;
    }

    public function audit(int $landlordId, int $rentId, string $result): void
    {
        $result = trim($result);
        if (! in_array($result, ['approved', 'rejected'], true)) {
            throw new AppException('Invalid review result');
        }

        $rent = RentModel::query()
            ->where('id', $rentId)
            ->where('landlord_id', $landlordId)
            ->first();

        if ($rent === null) {
            throw new AppException('Record not found');
        }

        if ((int) $rent->status !== RentModel::STATUS_PENDING_BIND) {
            throw new AppException('Only pending bind records can be reviewed');
        }

        $rent->status = $result === 'rejected'
            ? RentModel::STATUS_REJECTED
            : RentModel::STATUS_PENDING;
        $rent->save();
    }

    /**
     * @return list<string>
     */
    private function withRelations(): array
    {
        return [
            'user:id,first_name,last_name',
            'property:id,name,address',
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public function formatItem(RentModel $rent): array
    {
        $user = $rent->user;
        $property = $rent->property;
        $userName = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));

        return [
            'id' => (int) $rent->id,
            'initials' => $this->resolveInitials($userName),
            'user_name' => $userName,
            'rent' => $this->formatDisplayAmount((string) $rent->amount),
            'payday' => 'Day ' . (int) $rent->paid_at,
            'property_name' => trim((string) ($property?->name ?? '')),
            'property_address' => trim((string) ($property?->address ?? '')),
            'rental_date' => $this->formatEnglishDate($rent->created_at),
            'file_url' => file_url((string) $rent->file),
        ];
    }

    private function resolveInitials(string $name): string
    {
        $name = trim($name);
        if ($name === '') {
            return '?';
        }

        $parts = preg_split('/\s+/', $name) ?: [];
        if (count($parts) >= 2) {
            return mb_strtoupper(mb_substr($parts[0], 0, 1) . mb_substr($parts[1], 0, 1));
        }

        return mb_strtoupper(mb_substr($name, 0, 1));
    }

    private function formatDisplayAmount(string $amount): string
    {
        return number_format((float) $amount, 0, '.', ',');
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
