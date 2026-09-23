<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\LandlordAuthService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端信息
 */
#[Controller(prefix: '/landlord')]
class Info extends AbstractController
{
    #[Inject]
    protected LandlordAuthService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'info', methods: ['GET'])]
    public function info(): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success($this->service->info((int) $auth->id));
    }

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'delete-account', methods: ['POST'])]
    public function deleteAccount(): ResponseInterface
    {
        $auth = Context::get('landlord_auth');
        $this->service->deleteAccount((int) $auth->id);

        return $this->success();
    }

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'bank-detail', methods: ['POST'])]
    public function updateBankDetail(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('landlord_auth');
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'bank_name' => 'required|string|max:128',
            'bank_account' => 'required|string|max:64',
            'account_holder_name' => 'required|string|max:128',
            'bank_header_photo' => 'required|string|max:512',
        ], [
            'bank_name.required' => 'Bank name is required',
            'bank_name.max' => 'Bank name is too long',
            'bank_account.required' => 'Bank account number is required',
            'bank_account.max' => 'Bank account number is too long',
            'account_holder_name.required' => 'Account holder name is required',
            'account_holder_name.max' => 'Account holder name is too long',
            'bank_header_photo.required' => 'Bank header photo is required',
            'bank_header_photo.max' => 'Bank header photo path is too long',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->service->updateBankDetail((int) $auth->id, $params);

        return $this->success();
    }
}
