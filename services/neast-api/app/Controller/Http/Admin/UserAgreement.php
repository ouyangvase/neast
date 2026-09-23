<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Middleware\AdminAuthMiddleware;
use App\Service\AbstractAgreementService;
use App\Service\UserAgreementService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;

/**
 * 用户端协议
 */
#[Controller(prefix: '/admin/user-agreement')]
#[Middleware(AdminAuthMiddleware::class)]
class UserAgreement extends AbstractAgreementController
{
    #[Inject]
    protected UserAgreementService $service;

    protected function agreementService(): AbstractAgreementService
    {
        return $this->service;
    }
}
