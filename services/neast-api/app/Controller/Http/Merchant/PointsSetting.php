<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
use App\Service\PointsSettingService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端积分设置
 */
#[Controller(prefix: '/merchant/points-setting')]
class PointsSetting extends AbstractController
{
    #[Inject]
    protected PointsSettingService $service;

    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: '', methods: ['GET'])]
    public function show(): ResponseInterface
    {
        return $this->success($this->service->get());
    }
}
