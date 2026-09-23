<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Middleware\AdminAuthMiddleware;
use App\Service\AbstractAgreementService;
use App\Service\MerchantAgreementService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;

/**
 * 商家端协议
 */
#[Controller(prefix: '/admin/merchant-agreement')]
#[Middleware(AdminAuthMiddleware::class)]
class MerchantAgreement extends AbstractAgreementController
{
    #[Inject]
    protected MerchantAgreementService $service;

    protected function agreementService(): AbstractAgreementService
    {
        return $this->service;
    }
}
