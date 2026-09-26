<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Service\MessageService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端消息
 */
#[Controller(prefix: '/app/message')]
class Message extends AbstractController
{
    #[Inject]
    protected MessageService $service;

    /**
     * 消息列表
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        return $this->success($this->service->userList(
            (int) $auth->id,
            $page,
            $limit
        ));
    }

    /**
     * 是否有未读消息
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'has-unread', methods: ['GET'])]
    public function hasUnread(): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $unreadCount = $this->service->userUnreadCount((int) $auth->id);

        return $this->success([
            'has_unread' => $unreadCount > 0,
            'unread_count' => $unreadCount,
        ]);
    }

    /**
     * 全部已读
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'read-all', methods: ['POST'])]
    public function readAll(): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $this->service->userMarkAllRead((int) $auth->id);

        return $this->success();
    }
}
