<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Model\BannerModel;
use App\Service\BannerService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 首页 Banner 管理
 */
#[Controller(prefix: '/admin/banner')]
#[Middleware(AdminAuthMiddleware::class)]
class Banner extends AbstractController
{
    #[Inject]
    protected BannerService $service;

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
            'link' => 'nullable|string|max:512',
            'sort' => 'nullable|integer',
            'status' => 'nullable|integer|in:' . BannerModel::STATUS_DISABLED . ',' . BannerModel::STATUS_ENABLED,
        ], [
            'image.required' => 'Please upload banner image',
            'image.max' => 'Image path is too long',
            'link.max' => 'Link is too long',
            'sort.integer' => 'Invalid sort value',
            'status.in' => 'Invalid status',
        ]);

        if ($validator->fails()) {
            return $validator->errors()->first();
        }

        return null;
    }
}
