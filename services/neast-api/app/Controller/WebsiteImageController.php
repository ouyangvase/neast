<?php

declare(strict_types=1);

namespace App\Controller;

use App\Service\WebsiteImageService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 官网图片（公开读取）
 */
#[Controller(prefix: '/website/image')]
class WebsiteImageController extends AbstractController
{
    #[Inject]
    protected WebsiteImageService $service;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(): ResponseInterface
    {
        return $this->success([
            'items' => $this->service->publicList(),
        ]);
    }
}
