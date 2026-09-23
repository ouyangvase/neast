<?php

declare(strict_types=1);

namespace App\Service;

use App\Job\LandlordPushJob;
use App\Job\MerchantPushJob;
use App\Job\UserPushJob;

class PushQueueService
{
    public function __construct(private PushIndexService $pushIndexService)
    {
    }

    /**
     * @param array<string, mixed> $data
     */
    public function dispatchUser(int $userId, string $index, array $data = []): bool
    {
        if ($userId <= 0 || ! $this->pushIndexService->exists('user', $index)) {
            return false;
        }

        queue('user_push')->push(new UserPushJob($userId, $index, $data));

        return true;
    }

    /**
     * @param array<string, mixed> $data
     */
    public function dispatchMerchant(int $merchantId, string $index, array $data = []): bool
    {
        if ($merchantId <= 0 || ! $this->pushIndexService->exists('merchant', $index)) {
            return false;
        }

        queue('merchant_push')->push(new MerchantPushJob($merchantId, $index, $data));

        return true;
    }

    /**
     * @param array<string, mixed> $data
     */
    public function dispatchLandlord(int $landlordId, string $index, array $data = []): bool
    {
        if ($landlordId <= 0 || ! $this->pushIndexService->exists('landlord', $index)) {
            return false;
        }

        queue('landlord_push')->push(new LandlordPushJob($landlordId, $index, $data));

        return true;
    }
}
