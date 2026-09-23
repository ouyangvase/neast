<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\MessageService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端消息
 */
#[Controller(prefix: '/merchant/message')]
class Message extends AbstractController
{
    #[Inject]
    protected MessageService $service;

    /**
     * 消息列表
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('merchant_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        return $this->success($this->service->merchantList(
            (int) $auth->id,
            $page,
            $limit
        ));
    }

    /**
     * 全部已读
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'read-all', methods: ['POST'])]
    public function readAll(): ResponseInterface
    {
        $auth = Context::get('merchant_auth');
        $this->service->merchantMarkAllRead((int) $auth->id);

        return $this->success();
    }
}
