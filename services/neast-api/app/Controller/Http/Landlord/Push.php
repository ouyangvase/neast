<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\LandlordFcmTokenService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端 FCM 推送 Token
 */
#[Controller(prefix: '/landlord/push')]
class Push extends AbstractController
{
    #[Inject]
    protected LandlordFcmTokenService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
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

        $auth = Context::get('landlord_auth');
        $this->service->bind(
            (int) $auth->id,
            (string) $params['token'],
            (string) ($params['platform'] ?? '')
        );

        return $this->success();
    }

    #[Middleware(LandlordAuthMiddleware::class)]
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

        $auth = Context::get('landlord_auth');
        $this->service->unbind((int) $auth->id, (string) $params['token']);

        return $this->success();
    }
}
