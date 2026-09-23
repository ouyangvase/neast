<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppOptionalAuthMiddleware;
use App\Service\HomeService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端首页
 */
#[Controller(prefix: '/app/home')]
class Home extends AbstractController
{
    #[Inject]
    protected HomeService $service;

    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'dashboard', methods: ['GET'])]
    public function dashboard(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $userId = $auth ? (int) $auth->id : 0;
        $latitude = $this->parseCoordinate($request->input('latitude'));
        $longitude = $this->parseCoordinate($request->input('longitude'));

        return $this->success($this->service->dashboard(
            $userId,
            $latitude,
            $longitude
        ));
    }

    private function parseCoordinate(mixed $value): ?float
    {
        if ($value === null || $value === '') {
            return null;
        }

        if (! is_numeric($value)) {
            return null;
        }

        return (float) $value;
    }
}
