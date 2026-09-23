<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\LandlordPortfolioService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端资产概览
 */
#[Controller(prefix: '/landlord/portfolio')]
class Portfolio extends AbstractController
{
    #[Inject]
    protected LandlordPortfolioService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'detail', methods: ['GET'])]
    public function detail(): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success($this->service->detail((int) $auth->id));
    }
}
