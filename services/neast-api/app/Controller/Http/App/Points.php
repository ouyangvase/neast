<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Service\PointsDashboardService;
use App\Service\PointsLogService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端积分
 */
#[Controller(prefix: '/app/points')]
class Points extends AbstractController
{
    #[Inject]
    protected PointsLogService $service;

    #[Inject]
    protected PointsDashboardService $dashboardService;

    /**
     * 积分页聚合数据
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'dashboard', methods: ['GET'])]
    public function dashboard(): ResponseInterface
    {
        $auth = Context::get('app_auth');

        return $this->success($this->dashboardService->dashboard((int) $auth->id));
    }

    /**
     * 积分收支流水列表
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'logs', methods: ['GET'])]
    public function logs(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        return $this->success($this->service->listByUser(
            (int) $auth->id,
            $page,
            $limit
        ));
    }
}
