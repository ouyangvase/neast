<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\RentModel;
use App\Model\UserModel;
use Carbon\Carbon;
use Hyperf\Di\Annotation\Inject;

/**
 * Tent Score（租客信用评分）
 */
class TentScoreService
{
    #[Inject]
    protected RentPaymentStatsService $rentPaymentStatsService;

    /**
     * 获取用户 Tent Score 概览
     *
     * @return array<string, mixed>
     */
    public function info(int $userId): array
    {
        $score = (int) (UserModel::query()->whereKey($userId)->value('tent_score') ?? 500);
        $stats = $this->rentPaymentStatsService->aggregate($userId);
        $maxStreakMonths = (int) ($stats['maxStreakMonths'] ?? 0);
        $firstPaidAt = $stats['firstPaidAt'] ?? null;

        $verifiedLeases = RentModel::query()
            ->where('user_id', $userId)
            ->where('status', RentModel::STATUS_APPROVED)
            ->count();

        return [
            'score' => $score,
            'maxScore' => 1000,
            'ratingLabel' => $this->resolveRatingLabel($score),
            'maxStreakMonths' => $maxStreakMonths,
            'streakLabel' => $maxStreakMonths > 0 ? "{$maxStreakMonths} Month Streak" : '0 Month Streak',
            'streakStatus' => $this->rentPaymentStatsService->resolveStreakStatus($maxStreakMonths),
            'onTimePayments' => (int) ($stats['onTimePayments'] ?? 0),
            'latePayments' => (int) ($stats['latePayments'] ?? 0),
            'totalPaid' => $this->formatMoney((float) ($stats['totalPaid'] ?? 0)),
            'verifiedLeases' => $verifiedLeases,
            'since' => is_int($firstPaidAt)
                ? Carbon::createFromTimestamp($firstPaidAt)->format('M Y')
                : '-',
        ];
    }

    private function resolveRatingLabel(int $score): string
    {
        if ($score >= 900) {
            return 'Excellent';
        }

        if ($score >= 750) {
            return 'Good';
        }

        if ($score >= 600) {
            return 'Fair';
        }

        if ($score >= 500) {
            return 'Starting';
        }

        return 'Needs Improvement';
    }

    private function formatMoney(float $amount): string
    {
        return 'RM' . number_format($amount, 2, '.', ',');
    }
}
