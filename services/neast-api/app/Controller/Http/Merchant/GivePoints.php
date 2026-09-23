<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\GivePointsService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端发放积分
 */
#[Controller(prefix: '/merchant/give-points')]
class GivePoints extends AbstractController
{
    #[Inject]
    protected GivePointsService $service;

    /**
     * 今日佣金
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'today-commission', methods: ['GET'])]
    public function todayCommission(): ResponseInterface
    {
        $auth = Context::get('merchant_auth');

        return $this->success($this->service->todayCommission((int) $auth->id));
    }

    /**
     * Give Points 页统计
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'stats', methods: ['GET'])]
    public function stats(): ResponseInterface
    {
        $auth = Context::get('merchant_auth');

        return $this->success($this->service->stats((int) $auth->id));
    }

    /**
     * 通过用户 ID 查询客户手机号（扫码识别）
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'customer', methods: ['GET'])]
    public function customer(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'user_id' => 'required|integer|min:1',
        ], [
            'user_id.required' => 'User id is required',
            'user_id.integer' => 'Invalid user id',
            'user_id.min' => 'Invalid user id',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->customerByUserId(
            (int) $request->input('user_id')
        ));
    }

    /**
     * 确认发放积分
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'confirm', methods: ['POST'])]
    public function confirm(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'customer' => 'required|string|max:128',
            'amount' => 'required|numeric|min:0.01',
            'points' => 'required|integer|min:1',
            'merchant_id' => 'required|integer|min:1',
            'notes' => 'nullable|string|max:500',
            'receipt_number' => 'nullable|string|max:64',
            'receipt_path' => 'required|string|max:255',
        ], [
            'customer.required' => 'Customer identifier is required',
            'amount.required' => 'Receipt amount is required',
            'amount.numeric' => 'Invalid receipt amount',
            'amount.min' => 'Invalid receipt amount',
            'points.required' => 'Points is required',
            'points.integer' => 'Invalid points',
            'points.min' => 'Invalid points',
            'merchant_id.required' => 'Merchant is required',
            'merchant_id.integer' => 'Invalid merchant',
            'merchant_id.min' => 'Invalid merchant',
            'receipt_path.required' => 'Receipt file is required',
            'receipt_path.string' => 'Invalid receipt file',
            'receipt_path.max' => 'Invalid receipt file',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('merchant_auth');

        return $this->success($this->service->confirm(
            (int) $auth->id,
            $request->all()
        ));
    }
}
