<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Service\LandlordAuthService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端登录认证
 */
#[Controller(prefix: '/landlord/auth')]
class Auth extends AbstractController
{
    #[Inject]
    protected LandlordAuthService $service;

    #[RequestMapping(path: 'country-codes', methods: ['GET'])]
    public function countryCodes(): ResponseInterface
    {
        return $this->success($this->service->countryCodes());
    }

    #[RequestMapping(path: 'send-code', methods: ['POST'])]
    public function sendCode(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'phone' => 'required|string|max:32',
            'scene' => 'required|string|in:login,register',
        ], $this->sendCodeMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->service->sendCode((string) $params['phone'], (string) $params['scene']);

        return $this->success();
    }

    #[RequestMapping(path: 'login', methods: ['POST'])]
    public function login(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'phone' => 'required|string|max:32',
            'code' => 'required|string|size:6',
        ], $this->loginMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->login(
            (string) $params['phone'],
            (string) $params['code'],
        ));
    }

    #[RequestMapping(path: 'register', methods: ['POST'])]
    public function register(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'phone' => 'required|string|max:32',
            'code' => 'required|string|size:6',
            'first_name' => 'required|string|max:64',
            'last_name' => 'required|string|max:64',
        ], $this->registerMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->register(
            (string) $params['phone'],
            (string) $params['code'],
            (string) $params['first_name'],
            (string) $params['last_name'],
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
            'phone.required' => 'Please enter your phone number',
            'phone.max' => 'The phone number must be less than 32 characters',
            'scene.required' => 'Scene is required',
            'scene.in' => 'Scene must be login or register',
        ];
    }

    private function loginMessages(): array
    {
        return array_merge($this->sendCodeMessages(), [
            'code.required' => 'Please enter the verification code',
            'code.size' => 'The verification code must be 6 digits',
        ]);
    }

    private function registerMessages(): array
    {
        return array_merge($this->loginMessages(), [
            'first_name.required' => 'Please enter your first name',
            'first_name.max' => 'The first name must be less than 64 characters',
            'last_name.required' => 'Please enter your last name',
            'last_name.max' => 'The last name must be less than 64 characters',
        ]);
    }
}
