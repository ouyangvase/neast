<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\MerchantFcmTokenModel;

class MerchantFcmTokenService
{
    public function bind(int $merchantId, string $token, string $platform = ''): void
    {
        MerchantFcmTokenModel::query()
            ->where('merchant_id', $merchantId)
            ->delete();

        MerchantFcmTokenModel::query()->create([
            'merchant_id' => $merchantId,
            'token' => $token,
            'platform' => $platform,
        ]);
    }

    public function unbind(int $merchantId, string $token): void
    {
        MerchantFcmTokenModel::query()
            ->where('merchant_id', $merchantId)
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

        MerchantFcmTokenModel::query()
            ->whereIn('token', $tokens)
            ->delete();
    }
}
