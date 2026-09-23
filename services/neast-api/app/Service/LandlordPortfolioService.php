<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\RentHistoryModel;
use App\Model\RentModel;

class LandlordPortfolioService
{
    /**
     * 资产概览详情：本月 Rent Roll + 租客列表（t_rent）
     *
     * @return array<string, mixed>
     */
    public function detail(int $landlordId): array
    {
        $year = (int) date('Y');
        $month = (int) date('n');
        [$monthStart, $monthEnd] = $this->resolveMonthRange($year, $month);

        $rentRoll = number_format(
            (float) RentHistoryModel::query()
                ->where('status', '!=', RentHistoryModel::STATUS_CANCELLED)
                ->whereBetween('created_at', [$monthStart, $monthEnd])
                ->whereHas('rent', function ($rentQuery) use ($landlordId) {
                    $rentQuery->where('landlord_id', $landlordId)
                        ->where('status', '!=', RentModel::STATUS_TERMINATED);
                })
                ->sum('amount'),
            2,
            '.',
            ''
        );

        $tenants = RentModel::query()
            ->with([
                'user:id,first_name,last_name,avatar',
                'property:id,name,address',
            ])
            ->where('landlord_id', $landlordId)
            ->activeApproved()
            ->orderByDesc('id')
            ->get()
            ->map(fn (RentModel $rent) => $this->formatTenantItem($rent))
            ->all();

        return [
            'rent_roll' => $rentRoll,
            'tenant_count' => count($tenants),
            'tenants' => $tenants,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatTenantItem(RentModel $rent): array
    {
        $user = $rent->user;
        $property = $rent->property;
        $userName = trim(($user?->first_name ?? '') . ' ' . ($user?->last_name ?? ''));
        $propertyName = trim((string) ($property?->name ?? ''));
        $propertyAddress = trim((string) ($property?->address ?? ''));
        $address = $propertyName !== '' ? $propertyName : $propertyAddress;
        if ($address === '') {
            $address = trim((string) ($rent->landlord_account_name ?? ''));
        }

        return [
            'id' => (int) $rent->id,
            'initials' => $this->resolveInitials($userName),
            'name' => $userName,
            'address' => $address,
            'avatar' => file_url((string) ($user?->avatar ?? '')),
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

    private function resolveInitials(string $name): string
    {
        $name = trim($name);
        if ($name === '') {
            return '?';
        }

        return mb_strtoupper(mb_substr($name, 0, 1));
    }
}
