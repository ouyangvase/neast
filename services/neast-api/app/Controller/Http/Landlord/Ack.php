<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Exception\AppException;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\LandlordHomeService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端待确认收款
 */
#[Controller(prefix: '/landlord/ack')]
class Ack extends AbstractController
{
    #[Inject]
    protected LandlordHomeService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success([
            'items' => $this->service->needAckList((int) $auth->id),
        ]);
    }

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'confirm', methods: ['POST'])]
    public function confirm(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('landlord_auth');
        $id = (int) $request->input('id', 0);

        if ($id <= 0) {
            throw new AppException('Invalid record id');
        }

        $this->service->confirmAck((int) $auth->id, $id);

        return $this->success(null);
    }
}
