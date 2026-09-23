<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Service\AppAuthService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端登录认证
 */
#[Controller(prefix: '/app/auth')]
class Auth extends AbstractController
{
    #[Inject]
    protected AppAuthService $service;

    #[RequestMapping(path: 'country-codes', methods: ['GET'])]
    public function countryCodes(): ResponseInterface
    {
        return $this->success([
            ['code' => '+60'],
            ['code' => '+65'],
        ]);
    }

    #[RequestMapping(path: 'send-code', methods: ['POST'])]
    public function sendCode(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'account' => 'required|string|max:128',
        ], $this->sendCodeMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->service->sendCode((string) $params['account']);

        return $this->success();
    }

    #[RequestMapping(path: 'login', methods: ['POST'])]
    public function login(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'account' => 'required|string|max:128',
            'code' => 'required|string|size:6',
        ], $this->loginMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->login(
            (string) $params['account'],
            (string) $params['code']
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

    private function sendCodeMessages(): array
    {
        return [
            'account.required' => 'Please enter your phone number',
            'account.max' => 'The phone number must be less than 128 characters',
        ];
    }

    private function loginMessages(): array
    {
        return array_merge($this->sendCodeMessages(), [
            'code.required' => 'Please enter the verification code',
            'code.size' => 'The verification code must be 6 digits',
        ]);
    }
}
