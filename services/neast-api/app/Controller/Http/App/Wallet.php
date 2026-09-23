<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Service\WalletService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端钱包
 */
#[Controller(prefix: '/app/wallet')]
class Wallet extends AbstractController
{
    #[Inject]
    protected WalletService $service;

    /**
     * 钱包余额
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'balance', methods: ['GET'])]
    public function balance(): ResponseInterface
    {
        $auth = Context::get('app_auth');

        return $this->success($this->service->getBalance((int) $auth->id));
    }

    /**
     * 充值记录列表
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'topup/list', methods: ['GET'])]
    public function topupList(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;
        $yearInput = $request->input('year', null);
        $year = ($yearInput !== null && $yearInput !== '') ? (int) $yearInput : null;
        $monthInput = $request->input('month', null);
        $month = ($monthInput !== null && $monthInput !== '') ? (int) $monthInput : null;

        return $this->success($this->service->topupList(
            (int) $auth->id,
            $page,
            $limit,
            $year,
            $month
        ));
    }

    /**
     * 创建充值订单（Fiuu）
     */
    #[Middleware(AppAuthMiddleware::class)]
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

        $auth = Context::get('app_auth');

        return $this->success($this->service->createTopupOrder(
            (int) $auth->id,
            (float) $request->input('amount'),
            (string) $request->input('payment_method'),
            $request->input('payment_channel') !== null
                ? (string) $request->input('payment_channel')
                : null
        ));
    }

    /**
     * 验证 Fiuu 充值结果并入账
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'topup/verify', methods: ['POST'])]
    public function verifyTopup(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'order_id' => 'required|string|max:64',
            'txn_id' => 'required|string|max:64',
            'amount' => 'required|string|max:16',
            'status_code' => 'required|string|max:8',
            'msg_type' => 'required|string|max:8',
            'chksum' => 'required|string|max:64',
            'channel' => 'nullable|string|max:32',
        ], [
            'order_id.required' => 'Order ID is required',
            'txn_id.required' => 'Transaction ID is required',
            'amount.required' => 'Amount is required',
            'status_code.required' => 'Payment status is required',
            'msg_type.required' => 'Message type is required',
            'chksum.required' => 'Checksum is required',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->service->verifyTopup((int) $auth->id, [
            'order_id' => (string) $request->input('order_id'),
            'txn_id' => (string) $request->input('txn_id'),
            'amount' => (string) $request->input('amount'),
            'status_code' => (string) $request->input('status_code'),
            'msg_type' => (string) $request->input('msg_type'),
            'channel' => (string) $request->input('channel', ''),
            'chksum' => (string) $request->input('chksum'),
        ]));
    }
}
