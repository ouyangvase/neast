<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\LandlordHomeService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端首页
 */
#[Controller(prefix: '/landlord/home')]
class Home extends AbstractController
{
    #[Inject]
    protected LandlordHomeService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'detail', methods: ['GET'])]
    public function detail(): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success($this->service->dashboard((int) $auth->id));
    }
}
