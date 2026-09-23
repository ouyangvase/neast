<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\DashboardService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * Dashboard
 */
#[Controller(prefix: '/admin/dashboard')]
#[Middleware(AdminAuthMiddleware::class)]
class Dashboard extends AbstractController
{
    #[Inject]
    protected DashboardService $service;

    #[RequestMapping(path: 'stats', methods: ['GET'])]
    public function stats(): ResponseInterface
    {
        return $this->success($this->service->stats());
    }
}
