<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\DailyClosingService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端日结
 */
#[Controller(prefix: '/merchant/daily-closing')]
class DailyClosing extends AbstractController
{
    #[Inject]
    protected DailyClosingService $service;

    /**
     * 今日汇总
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'summary', methods: ['GET'])]
    public function summary(): ResponseInterface
    {
        $auth = Context::get('merchant_auth');

        return $this->success($this->service->summary((int) $auth->id));
    }

    /**
     * 今日交易列表
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'transactions', methods: ['GET'])]
    public function transactions(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('merchant_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 20);
        if ($limit <= 0) {
            $limit = 20;
        }

        return $this->success($this->service->transactions(
            (int) $auth->id,
            $page,
            $limit
        ));
    }
}
