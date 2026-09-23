<?php

declare(strict_types=1);

namespace App\Exception\Handler;

use Hyperf\ExceptionHandler\ExceptionHandler;
use Hyperf\HttpMessage\Exception\HttpException;
use Hyperf\HttpMessage\Exception\NotFoundHttpException;
use Hyperf\HttpMessage\Stream\SwooleStream;
use Hyperf\HttpServer\Contract\ResponseInterface as HttpResponse;
use Psr\Http\Message\ResponseInterface;
use Throwable;

class HttpExceptionHandler extends ExceptionHandler
{
    public function __construct(protected HttpResponse $response)
    {
    }

    public function handle(Throwable $throwable, ResponseInterface $response): ResponseInterface
    {
        // 处理 404 错误
        if ($throwable instanceof NotFoundHttpException) {
            $this->stopPropagation();
            return $this->response->json([
                'code' => 404,
                'message' => 'api not found',
                'data' => null,
            ]);
        }

        // 处理其他 HTTP 异常
        if ($throwable instanceof HttpException) {
            $this->stopPropagation();
            return $this->response->json([
                'code' => $throwable->getStatusCode(),
                'message' => $throwable->getMessage() ?: '请求异常',
                'data' => null,
            ]);
        }

        // 交给下一个异常处理器
        return $response;
    }

    public function isValid(Throwable $throwable): bool
    {
        return $throwable instanceof HttpException;
    }
} 