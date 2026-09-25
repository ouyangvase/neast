<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\RentHistoryModel;
use Carbon\Carbon;
use Hyperf\Di\Annotation\Inject;

class RentPaymentStatsService
{
    #[Inject]
    protected RentHistoryService $rentHistoryService;

    /**
     * 首页 Journey 摘要
     *
     * @return array<string, mixed>
     */
    public function journeySummary(int $userId): array
    {
        $stats = $this->aggregate($userId);
        $maxStreakMonths = (int) ($stats['maxStreakMonths'] ?? 0);

        return [
            'maxStreakMonths' => $maxStreakMonths,
            'streakLabel' => $this->streakLabel($maxStreakMonths),
            'streakStatus' => $this->resolveStreakStatus($maxStreakMonths),
        ];
    }

    /**
     * Tent Score 等使用的还款统计
     *
     * @return array<string, mixed>
     */
    public function aggregate(int $userId): array
    {
        $histories = RentHistoryModel::query()
            ->where('user_id', $userId)
            ->orderBy('last_paid_date')
            ->get(['amount', 'status', 'last_paid_date', 'user_paid_at']);

        $onTimePayments = 0;
        $latePayments = 0;
        $totalPaid = 0.0;
        $firstPaidAt = null;
        /** @var array<string, array{onTime: int, late: int, upcoming: int}> $months */
        $months = [];

        foreach ($histories as $history) {
            $status = (int) $history->status;
            if ($status === RentHistoryModel::STATUS_CANCELLED) {
                continue;
            }

            $row = $history->toArray();
            $payStatus = $this->rentHistoryService->resolvePayStatus($row);

            if ($payStatus === 'on_time') {
                ++$onTimePayments;
            } elseif ($payStatus === 'late') {
                ++$latePayments;
            }

            $monthKey = $this->monthKeyFromDate((string) $history->last_paid_date);
            if ($monthKey !== '') {
                if (!isset($months[$monthKey])) {
                    $months[$monthKey] = ['onTime' => 0, 'late' => 0, 'upcoming' => 0];
                }
                if ($payStatus === 'on_time') {
                    ++$months[$monthKey]['onTime'];
                } elseif ($payStatus === 'late') {
                    ++$months[$monthKey]['late'];
                } else {
                    ++$months[$monthKey]['upcoming'];
                }
            }

            if ($status === RentHistoryModel::STATUS_PAID || $status === RentHistoryModel::STATUS_SETTLED) {
                $totalPaid += (float) $history->amount;
                $paidAt = $history->user_paid_at;
                if ($paidAt !== null) {
                    $paidTimestamp = Carbon::parse((string) $paidAt)->timestamp;
                    if ($firstPaidAt === null || $paidTimestamp < $firstPaidAt) {
                        $firstPaidAt = $paidTimestamp;
                    }
                }
            }
        }

        return [
            'onTimePayments' => $onTimePayments,
            'latePayments' => $latePayments,
            'totalPaid' => $totalPaid,
            'firstPaidAt' => $firstPaidAt,
            'maxStreakMonths' => $this->calcCurrentStreakMonths($months),
        ];
    }

    public function streakLabel(int $months): string
    {
        if ($months <= 0) {
            return 'Pay on time and your streak starts here.';
        }

        return "{$months} Month Streak, don't stop!";
    }

    public function resolveStreakStatus(int $months): string
    {
        return $months > 0 ? "Don't stop" : 'Pay on time';
    }

    /**
     * Current run of fully on-time due months, ending at the latest closed month.
     *
     * @param array<string, array{onTime: int, late: int, upcoming: int}> $months
     */
    private function calcCurrentStreakMonths(array $months): int
    {
        $closed = [];
        foreach ($months as $monthKey => $counts) {
            if ($counts['late'] > 0) {
                $closed[$monthKey] = 'late';
                continue;
            }
            if ($counts['onTime'] > 0 && $counts['upcoming'] === 0) {
                $closed[$monthKey] = 'on_time';
            }
        }

        if ($closed === []) {
            return 0;
        }

        krsort($closed);
        $latestKey = (string) array_key_first($closed);
        if ($closed[$latestKey] !== 'on_time') {
            return 0;
        }

        $streak = 0;
        $cursor = Carbon::parse($latestKey . '-01')->startOfMonth();
        while (isset($closed[$cursor->format('Y-m')]) && $closed[$cursor->format('Y-m')] === 'on_time') {
            ++$streak;
            $cursor->subMonth();
        }

        return $streak;
    }

    private function monthKeyFromDate(string $date): string
    {
        $date = trim($date);
        if ($date === '') {
            return '';
        }

        try {
            return Carbon::parse($date)->format('Y-m');
        } catch (\Throwable) {
            return '';
        }
    }
}
