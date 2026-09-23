<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\UploadService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 文件上传
 */
#[Controller(prefix: '/admin/upload')]
#[Middleware(AdminAuthMiddleware::class)]
class Upload extends AbstractController
{
    #[Inject]
    protected UploadService $service;

    #[RequestMapping(path: 'file', methods: ['POST'])]
    public function file(RequestInterface $request): ResponseInterface
    {
        $file = $request->file('file');
        if (! $file) {
            return $this->error('File is required');
        }

        return $this->success($this->service->store($file));
    }
}
