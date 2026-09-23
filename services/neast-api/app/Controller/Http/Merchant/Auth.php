<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Service\MerchantAuthService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端登录认证
 */
#[Controller(prefix: '/merchant/auth')]
class Auth extends AbstractController
{
    #[Inject]
    protected MerchantAuthService $service;

    #[RequestMapping(path: 'login', methods: ['POST'])]
    public function login(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'account' => 'required|email|max:128',
            'password' => 'required|string|min:6|max:64',
        ], $this->loginMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->login(
            (string) $params['account'],
            (string) $params['password']
        ));
    }

    #[RequestMapping(path: 'refresh-token', methods: ['POST'])]
    public function refreshToken(RequestInterface $request): ResponseInterface
    {
        $refreshToken = trim((string) $request->input('refreshToken', ''));

        if ($refreshToken === '') {
            return $this->error('Refresh token is required');
        }

        return $this->success($this->service->refresh($refreshToken));
    }

    private function loginMessages(): array
    {
        return [
            'account.required' => 'Please enter your email',
            'account.email' => 'Please enter a valid email',
            'account.max' => 'The email must be less than 128 characters',
            'password.required' => 'Please enter your password',
            'password.min' => 'The password must be at least 6 characters',
            'password.max' => 'The password must be less than 64 characters',
        ];
    }
}
