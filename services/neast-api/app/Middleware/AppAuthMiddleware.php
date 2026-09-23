<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Kit\Token;
use App\Service\AppAuthService;
use Hyperf\Context\Context;
use Psr\Container\ContainerInterface;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\HttpServer\Contract\ResponseInterface as HttpResponse;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Psr\Http\Message\ServerRequestInterface;

/**
 * App 端鉴权中间件
 */
class AppAuthMiddleware implements MiddlewareInterface
{
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
        if (! $id || $token !== Token::get_user_token($id)) {
            return $this->expired();
        }

        Token::refresh_user_token($id, AppAuthService::IDLE_TTL);

        Context::set('app_auth', $payload->data);

        return $handler->handle($request);
    }

    private function resolveToken(ServerRequestInterface $request): string
    {
        $authorization = $request->getHeaderLine('Authorization');
        if ($authorization === '') {
            return '';
        }

        return trim(preg_replace('/^Bearer\s+/i', '', $authorization) ?? '');
    }

    private function expired(): ResponseInterface
    {
        return $this->response->json([
            'code' => 400,
            'message' => 'Login expired, please sign in again',
            'data' => null,
        ]);
    }
}
