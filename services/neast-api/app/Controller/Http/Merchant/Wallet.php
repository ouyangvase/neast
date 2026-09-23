<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\MerchantWalletService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端钱包
 */
#[Controller(prefix: '/merchant/wallet')]
class Wallet extends AbstractController
{
    #[Inject]
    protected MerchantWalletService $service;

    /**
     * 充值记录列表
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'topup/list', methods: ['GET'])]
    public function topupList(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('merchant_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        return $this->success($this->service->topupList(
            (int) $auth->id,
            $page,
            $limit
        ));
    }

    /**
     * 创建充值订单（Fiuu）
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'topup/create', methods: ['POST'])]
    public function createTopup(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'amount' => 'required|numeric|min:1.01',
            'payment_method' => 'required|string|max:16',
            'payment_channel' => 'nullable|string|max:32',
        ], [
            'amount.required' => 'Amount is required',
            'amount.numeric' => 'Invalid amount',
            'amount.min' => 'Amount must be at least 1.01',
            'payment_method.required' => 'Payment method is required',
            'payment_method.max' => 'Invalid payment method',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('merchant_auth');

        return $this->success($this->service->createTopupOrder(
            (int) $auth->id,
            (float) $request->input('amount'),
            (string) $request->input('payment_method'),
            $request->input('payment_channel') !== null
                ? (string) $request->input('payment_channel')
                : null
        ));
    }
}
