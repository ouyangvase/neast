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
            'streakLabel' => $maxStreakMonths > 0 ? "{$maxStreakMonths} Month Streak" : '0 Month Streak',
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
        $onTimeMonthKeys = [];

        foreach ($histories as $history) {
            $row = $history->toArray();
            $payStatus = $this->rentHistoryService->resolvePayStatus($row);
            $status = (int) $history->status;

            if ($payStatus === 'on_time') {
                ++$onTimePayments;
                $monthKey = $this->monthKeyFromDate((string) $history->last_paid_date);
                if ($monthKey !== '') {
                    $onTimeMonthKeys[$monthKey] = true;
                }
            } elseif ($payStatus === 'late') {
                ++$latePayments;
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
            'maxStreakMonths' => $this->calcMaxConsecutiveMonths(array_keys($onTimeMonthKeys)),
        ];
    }

    public function resolveStreakStatus(int $maxStreakMonths): string
    {
        if ($maxStreakMonths <= 0) {
            return 'Start your journey';
        }

        if ($maxStreakMonths < 6) {
            return 'Keep going';
        }

        if ($maxStreakMonths < 12) {
            return 'Great progress';
        }

        return 'Perfect Record';
    }

    /**
     * @param array<int, string> $monthKeys Y-m 格式，可无序
     */
    private function calcMaxConsecutiveMonths(array $monthKeys): int
    {
        if ($monthKeys === []) {
            return 0;
        }

        sort($monthKeys);

        $maxStreak = 1;
        $currentStreak = 1;

        for ($i = 1, $count = count($monthKeys); $i < $count; ++$i) {
            $prev = Carbon::parse($monthKeys[$i - 1] . '-01')->startOfMonth();
            $current = Carbon::parse($monthKeys[$i] . '-01')->startOfMonth();

            if ($prev->copy()->addMonth()->format('Y-m') === $current->format('Y-m')) {
                ++$currentStreak;
            } else {
                $currentStreak = 1;
            }

            $maxStreak = max($maxStreak, $currentStreak);
        }

        return $maxStreak;
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
