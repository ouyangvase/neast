<?php

declare(strict_types=1);

namespace App\Service;

use Hyperf\Di\Annotation\Inject;

class HomeService
{
    #[Inject]
    protected RentService $rentService;

    #[Inject]
    protected CouponService $couponService;

    #[Inject]
    protected MerchantService $merchantService;

    #[Inject]
    protected RentPaymentStatsService $rentPaymentStatsService;

    #[Inject]
    protected BannerService $bannerService;

    #[Inject]
    protected UserActiveService $userActiveService;

    #[Inject]
    protected UserLocationService $userLocationService;

    /**
     * App 首页聚合数据
     *
     * @return array<string, mixed>
     */
    public function dashboard(int $userId, ?float $latitude = null, ?float $longitude = null): array
    {
        if ($userId > 0) {
            $this->userActiveService->recordDailyActive($userId);
        }

        $nearbyDeals = [];
        if ($latitude !== null && $longitude !== null) {
            if ($userId > 0) {
                $this->userLocationService->updateLastLocation($userId, $latitude, $longitude);
            }

            $nearby = $this->merchantService->appNearbyList(
                $latitude,
                $longitude,
                1,
                10
            );
            $nearbyDeals = $nearby['items'] ?? [];
        }

        return [
            'nextRent' => $userId > 0 ? $this->rentService->appNextRent($userId) : null,
            'todayReward' => $this->couponService->appLatest(),
            'nearbyDeals' => $nearbyDeals,
            'journey' => $userId > 0
                ? $this->rentPaymentStatsService->journeySummary($userId)
                : [
                    'maxStreakMonths' => 0,
                    'streakLabel' => '',
                    'streakStatus' => '',
                ],
            'banners' => $this->bannerService->appList(),
        ];
    }
}
