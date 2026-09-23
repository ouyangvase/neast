<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\SettlementService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端结算
 */
#[Controller(prefix: '/merchant/settlement')]
class Settlement extends AbstractController
{
    #[Inject]
    protected SettlementService $service;

    /**
     * 结算概览
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'overview', methods: ['GET'])]
    public function overview(): ResponseInterface
    {
        $auth = Context::get('merchant_auth');

        return $this->success($this->service->overview((int) $auth->id));
    }

    /**
     * 钱包余额支付结算
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'pay/wallet', methods: ['POST'])]
    public function payByWallet(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'bill_id' => 'required|integer|min:1',
            'payment_method' => 'required|string|max:16',
        ], [
            'bill_id.required' => 'Bill is required',
            'bill_id.integer' => 'Invalid bill',
            'bill_id.min' => 'Invalid bill',
            'payment_method.required' => 'Payment method is required',
            'payment_method.max' => 'Invalid payment method',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('merchant_auth');

        return $this->success($this->service->payByWallet(
            (int) $auth->id,
            (int) $request->input('bill_id'),
            (string) $request->input('payment_method')
        ));
    }

    /**
     * 创建结算 H5 支付订单
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'pay/create', methods: ['POST'])]
    public function createPayOrder(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'bill_id' => 'required|integer|min:1',
            'payment_method' => 'required|string|max:16',
            'payment_channel' => 'nullable|string|max:32',
        ], [
            'bill_id.required' => 'Bill is required',
            'bill_id.integer' => 'Invalid bill',
            'bill_id.min' => 'Invalid bill',
            'payment_method.required' => 'Payment method is required',
            'payment_method.max' => 'Invalid payment method',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('merchant_auth');

        return $this->success($this->service->createPayOrder(
            (int) $auth->id,
            (int) $request->input('bill_id'),
            (string) $request->input('payment_method'),
            $request->input('payment_channel') !== null
                ? (string) $request->input('payment_channel')
                : null
        ));
    }
}
