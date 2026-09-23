<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\RoleService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 角色管理
 */
#[Controller(prefix: '/admin/role')]
#[Middleware(AdminAuthMiddleware::class)]
class Role extends AbstractController
{
    #[Inject]
    protected RoleService $service;

    /**
     * 角色列表
     */
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success(
            $this->service->list($request)
        );
    }

    /**
     * 角色详情
     */
    #[RequestMapping(path: 'id/{id}', methods: ['GET'])]
    public function detail(int $id): ResponseInterface
    {
        return $this->success(
            $this->service->detail($id)
        );
    }

    /**
     * 角色下拉（启用角色）
     */
    #[RequestMapping(path: 'options', methods: ['GET'])]
    public function options(): ResponseInterface
    {
        return $this->success(
            $this->service->options()
        );
    }

    /**
     * 创建角色
     */
    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:64',
        ], [
            'name.required' => 'Please enter the role name',
            'name.max' => 'The role name must be less than 64 characters',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success(
            $this->service->create($params)
        );
    }

    /**
     * 更新角色
     */
    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:64',
        ], [
            'name.required' => 'Please enter the role name',
            'name.max' => 'The role name must be less than 64 characters',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success(
            $this->service->update($id, $params)
        );
    }

    /**
     * 删除角色
     */
    #[RequestMapping(path: 'id/{id}', methods: ['DELETE'])]
    public function delete(int $id): ResponseInterface
    {
        $this->service->delete($id);

        return $this->success();
    }
}
