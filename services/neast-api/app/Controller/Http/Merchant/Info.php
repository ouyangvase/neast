<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\MerchantAuthService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端信息
 */
#[Controller(prefix: '/merchant')]
class Info extends AbstractController
{
    #[Inject]
    protected MerchantAuthService $service;

    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'info', methods: ['GET'])]
    public function info(): ResponseInterface
    {
        $auth = Context::get('merchant_auth');

        return $this->success($this->service->info((int) $auth->id));
    }
}
