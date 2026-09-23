<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\MerchantCategoryService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家分类
 */
#[Controller(prefix: '/admin/merchant-category')]
#[Middleware(AdminAuthMiddleware::class)]
class MerchantCategory extends AbstractController
{
    #[Inject]
    protected MerchantCategoryService $service;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->service->list($request));
    }

    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:64',
        ], [
            'name.required' => 'Please enter the category name',
            'name.max' => 'The category name must be less than 64 characters',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->create($params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:64',
        ], [
            'name.required' => 'Please enter the category name',
            'name.max' => 'The category name must be less than 64 characters',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->update($id, $params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['DELETE'])]
    public function delete(int $id): ResponseInterface
    {
        $this->service->delete($id);

        return $this->success();
    }

    #[RequestMapping(path: 'options', methods: ['GET'])]
    public function options(): ResponseInterface
    {
        return $this->success($this->service->options());
    }
}
