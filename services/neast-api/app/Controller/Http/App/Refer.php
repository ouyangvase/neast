<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Service\ReferService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端推荐
 */
#[Controller(prefix: '/app/refer')]
class Refer extends AbstractController
{
    #[Inject]
    protected ReferService $service;

    /**
     * 推荐页聚合数据
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'dashboard', methods: ['GET'])]
    public function dashboard(): ResponseInterface
    {
        $auth = Context::get('app_auth');

        return $this->success($this->service->dashboard((int) $auth->id));
    }
}
