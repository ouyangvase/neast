<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\RentService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端租约
 */
#[Controller(prefix: '/landlord/rent')]
class Rent extends AbstractController
{
    #[Inject]
    protected RentService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'id/{id}', methods: ['GET'])]
    public function detail(int $id): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success($this->service->landlordDetail((int) $auth->id, $id));
    }

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'id/{id}/terminate', methods: ['PUT'])]
    public function terminate(int $id, RequestInterface $request): ResponseInterface
    {
        $reason = trim((string) $request->input('reason', ''));

        $validator = di(ValidatorFactory::class)->make(
            ['reason' => $reason],
            ['reason' => 'nullable|string|max:255'],
            [
                'reason.max' => 'Reason is too long',
            ]
        );

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('landlord_auth');

        $this->service->landlordTerminate((int) $auth->id, $id, $reason);

        return $this->success();
    }
}
