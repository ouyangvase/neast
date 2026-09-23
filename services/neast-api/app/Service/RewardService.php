<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\UserModel;
use Hyperf\Di\Annotation\Inject;

class RewardService
{
    #[Inject]
    protected RewardTierService $rewardTierService;

    #[Inject]
    protected UserPointsService $userPointsService;

    #[Inject]
    protected CouponService $couponService;

    #[Inject]
    protected MerchantService $merchantService;

    /**
     * App Reward 页聚合数据
     *
     * @return array<string, mixed>
     */
    public function dashboard(int $userId, ?float $latitude = null, ?float $longitude = null): array
    {
        $points = 0;
        $pointsExpiringText = '';

        if ($userId > 0) {
            $user = UserModel::query()->find($userId);
            if (! $user) {
                throw new AppException('User not found');
            }

            $points = $this->userPointsService->availableBalance($userId);
            $pointsExpiringText = $this->userPointsService->expiringText($userId);
        }

        $nearbyRewards = [];
        if ($latitude !== null && $longitude !== null) {
            $nearby = $this->merchantService->appNearbyList(
                $latitude,
                $longitude,
                1,
                10
            );
            $nearbyRewards = $nearby['items'] ?? [];
        }

        $featured = $this->couponService->appList($userId, null, 1, 10);

        return [
            'points' => $points,
            'pointsExpiringText' => $pointsExpiringText,
            'tier' => $this->rewardTierService->resolve($points),
            'tiers' => $this->rewardTierService->all(),
            'featuredRewards' => $featured['items'] ?? [],
            'nearbyRewards' => $nearbyRewards,
        ];
    }
}
