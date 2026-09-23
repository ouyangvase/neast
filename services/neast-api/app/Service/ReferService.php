<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\RentHistoryModel;
use App\Model\UserModel;
use Hyperf\Di\Annotation\Inject;

class ReferService
{
    #[Inject]
    protected PointsSettingService $pointsSettingService;

    /**
     * 推荐页聚合数据
     *
     * @return array<string, mixed>
     */
    public function dashboard(int $userId): array
    {
        $user = UserModel::query()->find($userId);
        if (! $user) {
            throw new AppException('User not found');
        }

        $totalEarnedPoints = (int) RentHistoryModel::query()
            ->where('inviter_user_id', $userId)
            ->sum('inviter_reward_points');

        $invitedCount = (int) UserModel::query()
            ->where('pid', $userId)
            ->count();

        $settings = $this->pointsSettingService->get();

        $inviteUrl = (string) env('REFERR_INVITE_URL', '');

        return [
            'total_earned_points' => $totalEarnedPoints,
            'invited_count' => $invitedCount,
            'max_invite_limit' => UserModel::MAX_INVITE_LIMIT,
            'next_reward_points' => (int) ($settings['inviter_reward_points'] ?? 0),
            'invitation_code' => (string) $user->invitation_code,
            'invitee_reward_points' => (int) ($settings['invitee_reward_points'] ?? 0),
            'invite_url' => $inviteUrl,
        ];
    }
}
