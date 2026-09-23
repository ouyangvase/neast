<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\LandlordFcmTokenModel;

class LandlordFcmTokenService
{
    public function bind(int $landlordId, string $token, string $platform = ''): void
    {
        LandlordFcmTokenModel::query()
            ->where('landlord_id', $landlordId)
            ->delete();

        LandlordFcmTokenModel::query()->create([
            'landlord_id' => $landlordId,
            'token' => $token,
            'platform' => $platform,
        ]);
    }

    public function unbind(int $landlordId, string $token): void
    {
        LandlordFcmTokenModel::query()
            ->where('landlord_id', $landlordId)
            ->where('token', $token)
            ->delete();
    }

    /**
     * @param array<int, string> $tokens
     */
    public function removeInvalidTokens(array $tokens): void
    {
        if ($tokens === []) {
            return;
        }

        LandlordFcmTokenModel::query()
            ->whereIn('token', $tokens)
            ->delete();
    }
}
