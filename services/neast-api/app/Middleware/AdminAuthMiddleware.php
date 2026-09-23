<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Kit\Token;
use Hyperf\Context\Context;
use Psr\Container\ContainerInterface;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\HttpServer\Contract\ResponseInterface as HttpResponse;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Psr\Http\Message\ServerRequestInterface;

// 管理端鉴权中间件
class AdminAuthMiddleware implements MiddlewareInterface
{
    /**
     * 空闲过期窗口（秒）
     */
    private const IDLE_TTL = 7200;

    public function __construct(
        protected ContainerInterface $container,
        protected RequestInterface $request,
        protected HttpResponse $response
    ) {
    }

    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $token = $this->resolveToken($request);

        if ($token === '') {
            return $this->expired();
        }

        $payload = Token::decodeToken($token);
        if (! $payload) {
            return $this->expired();
        }

        $id = $payload->data->id ?? 0;
        if (! $id || $token !== Token::get_admin_token($id)) {
            return $this->expired();
        }

        // 滑动续期：只要有请求就刷新过期时间
        Token::refresh_admin_token($id, self::IDLE_TTL);

        Context::set('auth', $payload->data);

        return $handler->handle($request);
    }

    /**
     * 从 Authorization: Bearer 头解析 token
     */
    private function resolveToken(ServerRequestInterface $request): string
    {
        $authorization = $request->getHeaderLine('Authorization');
        if ($authorization === '') {
            return '';
        }

        return trim(preg_replace('/^Bearer\s+/i', '', $authorization) ?? '');
    }

    /**
     * 登录过期响应（HTTP 200，业务 code 400 由前端拦截跳登录）
     */
    private function expired(): ResponseInterface
    {
        return $this->response->json([
            'code' => 400,
            'message' => 'Login expired, please login again',
            'data' => null,
        ]);
    }
}
