<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

namespace App\Exception;

use App\Constants\ErrorCode;
use Hyperf\Server\Exception\ServerException;
use Throwable;

class AppException extends ServerException
{
    public function __construct(string $message = null, Throwable $previous = null)
    {
        if (is_null($message)) {
            $message = ErrorCode::getMessage(500);
        }

        parent::__construct($message, 500, $previous);
    }
}
