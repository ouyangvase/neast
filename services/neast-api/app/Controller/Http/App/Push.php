<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Service\UserFcmTokenService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端 FCM 推送 Token
 */
#[Controller(prefix: '/app/push')]
class Push extends AbstractController
{
    #[Inject]
    protected UserFcmTokenService $service;

    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'add-fcm-token', methods: ['POST'])]
    public function addFcmToken(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'token' => 'required|string|max:512',
            'platform' => 'nullable|string|in:ios,android',
        ], [
            'token.required' => 'FCM token is required',
            'token.max' => 'FCM token is too long',
            'platform.in' => 'Invalid platform',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');
        $this->service->bind(
            (int) $auth->id,
            (string) $params['token'],
            (string) ($params['platform'] ?? '')
        );

        return $this->success();
    }

    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'delete-fcm-token', methods: ['POST'])]
    public function deleteFcmToken(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'token' => 'required|string|max:512',
        ], [
            'token.required' => 'FCM token is required',
            'token.max' => 'FCM token is too long',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');
        $this->service->unbind((int) $auth->id, (string) $params['token']);

        return $this->success();
    }
}
