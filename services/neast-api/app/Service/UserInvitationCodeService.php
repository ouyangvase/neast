<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\UserModel;

/**
 * 用户邀请码生成器。
 */
class UserInvitationCodeService
{
    private const CODE_LENGTH = 6;

    private const CHARSET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    private const MAX_ATTEMPTS = 20;

    public function generateUnique(): string
    {
        $charset = self::CHARSET;
        $charsetLength = strlen($charset) - 1;

        for ($attempt = 0; $attempt < self::MAX_ATTEMPTS; ++$attempt) {
            $code = '';
            for ($i = 0; $i < self::CODE_LENGTH; ++$i) {
                $code .= $charset[random_int(0, $charsetLength)];
            }

            if (! UserModel::query()->where('invitation_code', $code)->exists()) {
                return $code;
            }
        }

        throw new AppException('Failed to generate invitation code');
    }
}
