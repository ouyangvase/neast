<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\RoleService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 权限（供角色分配，只读树）
 */
#[Controller(prefix: '/admin/permission')]
#[Middleware(AdminAuthMiddleware::class)]
class Permission extends AbstractController
{
    #[Inject]
    protected RoleService $service;

    /**
     * 权限树
     */
    #[RequestMapping(path: 'tree', methods: ['GET'])]
    public function tree(): ResponseInterface
    {
        return $this->success(
            $this->service->permissionTree()
        );
    }
}
