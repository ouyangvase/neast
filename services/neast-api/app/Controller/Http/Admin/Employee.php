<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\AdminService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 员工(管理员)管理
 */
#[Controller(prefix: '/admin/employee')]
#[Middleware(AdminAuthMiddleware::class)]
class Employee extends AbstractController
{
    #[Inject]
    protected AdminService $service;

    /**
     * 员工列表
     */
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success(
            $this->service->list($request)
        );
    }

    /**
     * 创建员工
     */
    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'real_name' => 'required|string|max:64',
            'username' => 'required|string|max:64',
            'role_id' => 'required|integer',
        ], [
            'real_name.required' => 'Please enter the employee name',
            'real_name.max' => 'The employee name must be less than 64 characters',
            'username.required' => 'Please enter the login account',
            'username.max' => 'The login account must be less than 64 characters',
            'role_id.required' => 'Please assign the system role',
            'role_id.integer' => 'Please select a valid system role',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success(
            $this->service->create($params)
        );
    }

    /**
     * 更新员工
     */
    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'real_name' => 'required|string|max:64',
            'role_id' => 'required|integer',
        ], [
            'real_name.required' => 'Please enter the employee name',
            'real_name.max' => 'The employee name must be less than 64 characters',
            'role_id.required' => 'Please assign the system role',
            'role_id.integer' => 'Please select a valid system role',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success(
            $this->service->update($id, $params)
        );
    }

    /**
     * 删除员工
     */
    #[RequestMapping(path: 'id/{id}', methods: ['DELETE'])]
    public function delete(int $id): ResponseInterface
    {
        $this->service->delete($id);

        return $this->success();
    }

    /**
     * 状态切换
     */
    #[RequestMapping(path: 'id/{id}/status', methods: ['PUT'])]
    public function status(int $id, RequestInterface $request): ResponseInterface
    {
        $status = (int) $request->input('status', 1);
        $this->service->toggleStatus($id, $status);

        return $this->success();
    }

    /**
     * 重置密码
     */
    #[RequestMapping(path: 'id/{id}/reset-password', methods: ['PUT'])]
    public function resetPassword(int $id): ResponseInterface
    {
        $this->service->resetPassword($id);

        return $this->success();
    }
}
