<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\RentHistoryService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端收款记录
 */
#[Controller(prefix: '/landlord/record')]
class Record extends AbstractController
{
    #[Inject]
    protected RentHistoryService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success($this->service->landlordSettledList((int) $auth->id, $request));
    }
}
