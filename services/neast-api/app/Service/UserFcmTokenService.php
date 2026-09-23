<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\UserFcmTokenModel;

class UserFcmTokenService
{
    public function bind(int $userId, string $token, string $platform = ''): void
    {
        UserFcmTokenModel::query()
            ->where('user_id', $userId)
            ->delete();

        UserFcmTokenModel::query()->create([
            'user_id' => $userId,
            'token' => $token,
            'platform' => $platform,
        ]);
    }

    public function unbind(int $userId, string $token): void
    {
        UserFcmTokenModel::query()
            ->where('user_id', $userId)
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

        UserFcmTokenModel::query()
            ->whereIn('token', $tokens)
            ->delete();
    }
}
