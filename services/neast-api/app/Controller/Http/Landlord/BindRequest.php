<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Exception\AppException;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\LandlordBindRequestService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端待绑定申请
 */
#[Controller(prefix: '/landlord/bind-request')]
class BindRequest extends AbstractController
{
    #[Inject]
    protected LandlordBindRequestService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success([
            'items' => $this->service->list((int) $auth->id),
        ]);
    }

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'audit', methods: ['POST'])]
    public function audit(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('landlord_auth');
        $id = (int) $request->input('id', 0);
        $result = trim((string) $request->input('result', ''));

        if ($id <= 0) {
            throw new AppException('Invalid record id');
        }

        $this->service->audit((int) $auth->id, $id, $result);

        return $this->success();
    }
}
