<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\WebsiteImageService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 官网图片管理
 */
#[Controller(prefix: '/admin/website-image')]
#[Middleware(AdminAuthMiddleware::class)]
class WebsiteImage extends AbstractController
{
    #[Inject]
    protected WebsiteImageService $service;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->service->list($request));
    }

    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();
        $error = $this->validatePayload($params);
        if ($error !== null) {
            return $this->error($error);
        }

        return $this->success($this->service->create($params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();
        $error = $this->validatePayload($params);
        if ($error !== null) {
            return $this->error($error);
        }

        return $this->success($this->service->update($id, $params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['DELETE'])]
    public function delete(int $id): ResponseInterface
    {
        $this->service->delete($id);

        return $this->success();
    }

    /**
     * @param array<string, mixed> $params
     */
    private function validatePayload(array $params): ?string
    {
        $validator = di(ValidatorFactory::class)->make($params, [
            'image' => 'required|string|max:512',
        ], [
            'image.required' => 'Please upload image',
            'image.max' => 'Image path is too long',
        ]);

        if ($validator->fails()) {
            return $validator->errors()->first();
        }

        return null;
    }
}
