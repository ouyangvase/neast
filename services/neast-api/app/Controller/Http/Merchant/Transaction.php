<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\MerchantTransactionService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端交易记录
 */
#[Controller(prefix: '/merchant/transaction')]
class Transaction extends AbstractController
{
    #[Inject]
    protected MerchantTransactionService $service;

    /**
     * 积分发放记录
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'points', methods: ['GET'])]
    public function points(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('merchant_auth');
        $year = max(1970, (int) $request->input('year', (int) date('Y')));
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        return $this->success($this->service->pointsList(
            (int) $auth->id,
            $year,
            $page,
            $limit
        ));
    }

    /**
     * 优惠券核销记录
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'redeemed', methods: ['GET'])]
    public function redeemed(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('merchant_auth');
        $year = max(1970, (int) $request->input('year', (int) date('Y')));
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        return $this->success($this->service->redeemedList(
            (int) $auth->id,
            $year,
            $page,
            $limit
        ));
    }
}
