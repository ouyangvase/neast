<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Middleware\AdminAuthMiddleware;
use App\Service\AbstractAgreementService;
use App\Service\LandlordAgreementService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;

/**
 * 房东端协议
 */
#[Controller(prefix: '/admin/landlord-agreement')]
#[Middleware(AdminAuthMiddleware::class)]
class LandlordAgreement extends AbstractAgreementController
{
    #[Inject]
    protected LandlordAgreementService $service;

    protected function agreementService(): AbstractAgreementService
    {
        return $this->service;
    }
}
