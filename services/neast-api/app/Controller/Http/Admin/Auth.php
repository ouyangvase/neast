<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\AuthService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 管理端登录认证
 */
#[Controller(prefix: '/admin/auth')]
class Auth extends AbstractController
{
    #[Inject]
    protected AuthService $service;

    /**
     * 登录
     */
    #[RequestMapping(path: 'login', methods: ['POST'])]
    public function login(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'username' => 'required|string',
            'password' => 'required|string',
        ], [
            'username.required' => 'Please enter the username',
            'password.required' => 'Please enter the password',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success(
            $this->service->login((string) $params['username'], (string) $params['password'])
        );
    }

    /**
     * 当前用户信息
     */
    #[Middleware(AdminAuthMiddleware::class)]
    #[RequestMapping(path: 'info', methods: ['GET'])]
    public function info(): ResponseInterface
    {
        $auth = Context::get('auth');
        return $this->success(
            $this->service->info((int) $auth->id)
        );
    }

    /**
     * 登出
     */
    #[Middleware(AdminAuthMiddleware::class)]
    #[RequestMapping(path: 'logout', methods: ['POST'])]
    public function logout(): ResponseInterface
    {
        $auth = Context::get('auth');
        $this->service->logout((int) $auth->id);

        return $this->success();
    }

    /**
     * 修改密码（当前登录用户）
     */
    #[Middleware(AdminAuthMiddleware::class)]
    #[RequestMapping(path: 'change-password', methods: ['POST'])]
    public function changePassword(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'old_password' => 'required|string',
            'new_password' => 'required|string|min:6',
        ], [
            'old_password.required' => 'Please enter the current password',
            'new_password.required' => 'Please enter the new password',
            'new_password.min' => 'The new password must be at least 6 characters',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('auth');
        $this->service->changePassword(
            (int) $auth->id,
            (string) $params['old_password'],
            (string) $params['new_password']
        );

        return $this->success();
    }
}
