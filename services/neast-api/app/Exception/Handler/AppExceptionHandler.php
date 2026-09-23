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

namespace App\Exception\Handler;

use Hyperf\Contract\StdoutLoggerInterface;
use Hyperf\ExceptionHandler\ExceptionHandler;
use Hyperf\HttpMessage\Stream\SwooleStream;
use Psr\Http\Message\ResponseInterface;
use Throwable;

class AppExceptionHandler extends ExceptionHandler
{
    public function __construct(protected StdoutLoggerInterface $logger)
    {
    }

    public function handle(Throwable $throwable, ResponseInterface $response): ResponseInterface
    {
        // 记录错误日志
        $this->logger->error(sprintf('%s[%s] in %s', $throwable->getMessage(), $throwable->getLine(), $throwable->getFile()));

        // 格式化返回的错误信息
        $data = json_encode([
            'code' => 500,
            'message' => $throwable->getMessage(),
            'data' => null,
        ], JSON_UNESCAPED_UNICODE);

        // 阻止异常冒泡
        $this->stopPropagation();

        return $response
            ->withHeader('Server', 'Hyperf')
            ->withHeader('Content-Type', 'application/json')
            ->withBody(new SwooleStream($data));
    }

    public function isValid(Throwable $throwable): bool
    {
        return true;
    }
}
