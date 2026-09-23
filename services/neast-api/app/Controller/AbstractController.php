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

namespace App\Controller;

use Hyperf\HttpServer\Contract\ResponseInterface;
use Psr\Container\ContainerInterface;

abstract class AbstractController
{
    public function __construct(
        protected ContainerInterface $container,
        protected ResponseInterface $response
    ) {
    }

    /**
     * 成功响应
     * @param mixed $data 响应数据
     * @param string $message 响应消息
     * @param int $code 响应代码
     */
    protected function success(mixed $data = null, string $message = ''): \Psr\Http\Message\ResponseInterface
    {
        return $this->response->json([
            'code' => 200,
            'message' => $message,
            'data' => $data,
        ]);
    }

    /**
     * 错误响应
     * @param string $message 错误消息
     * @param int $code 错误代码
     * @param mixed $data 错误数据
     */
    protected function error(string $message = '', mixed $data = null, int $code = 500): \Psr\Http\Message\ResponseInterface
    {
        return $this->response->json([
            'code' => $code,
            'message' => $message,
            'data' => $data,
        ]);
    }
}
