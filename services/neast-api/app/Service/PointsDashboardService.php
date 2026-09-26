<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\UserModel;
use Hyperf\Di\Annotation\Inject;

class PointsDashboardService
{
    #[Inject]
    protected UserPointsService $userPointsService;

    #[Inject]
    protected RewardTierService $rewardTierService;

    #[Inject]
    protected CouponService $couponService;

    #[Inject]
    protected PointsSettingService $pointsSettingService;

    /**
     * 积分页聚合数据
     *
     * @return array<string, mixed>
     */
    public function dashboard(int $userId): array
    {
        $user = UserModel::query()->find($userId);
        if (! $user) {
            throw new AppException('User not found');
        }

        $points = $this->userPointsService->availableBalance($userId);
        $tier = $this->rewardTierService->resolve($points);
        $settings = $this->pointsSettingService->get();

        return [
            'points' => $points,
            'tier' => ['current' => $tier['current']],
            'expiring' => $this->userPointsService->expiringSummary($userId),
            'coupon_count' => $this->couponService->appMyCount($userId)['count'],
            'inviter_reward_points' => (int) ($settings['inviter_reward_points'] ?? 0),
            'invitee_reward_points' => (int) ($settings['invitee_reward_points'] ?? 0),
        ];
    }
}
