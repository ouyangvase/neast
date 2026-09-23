<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\PointsSettingService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 积分设置
 */
#[Controller(prefix: '/admin/points-setting')]
#[Middleware(AdminAuthMiddleware::class)]
class PointsSetting extends AbstractController
{
    #[Inject]
    protected PointsSettingService $service;

    #[RequestMapping(path: '', methods: ['GET'])]
    public function show(): ResponseInterface
    {
        return $this->success($this->service->get());
    }

    #[RequestMapping(path: '', methods: ['PUT'])]
    public function update(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'rent_points_multiplier' => 'required|numeric|min:0|regex:/^\d+(\.\d{1})?$/',
            'spend_points_multiplier' => 'required|numeric|min:0|regex:/^\d+(\.\d{1})?$/',
            'yuan_to_points' => 'required|integer|min:1',
            'inviter_reward_points' => 'required|integer|min:0',
            'invitee_reward_points' => 'required|integer|min:0',
        ], [
            'rent_points_multiplier.required' => 'Please enter rent points multiplier',
            'rent_points_multiplier.regex' => 'Rent points multiplier allows one decimal place',
            'spend_points_multiplier.required' => 'Please enter spend points multiplier',
            'spend_points_multiplier.regex' => 'Spend points multiplier allows one decimal place',
            'yuan_to_points.required' => 'Please enter points per RM',
            'yuan_to_points.integer' => 'Points per RM must be an integer',
            'yuan_to_points.min' => 'Points per RM must be at least 1',
            'inviter_reward_points.required' => 'Please enter inviter reward points',
            'inviter_reward_points.integer' => 'Inviter reward points must be an integer',
            'inviter_reward_points.min' => 'Inviter reward points cannot be negative',
            'invitee_reward_points.required' => 'Please enter invitee reward points',
            'invitee_reward_points.integer' => 'Invitee reward points must be an integer',
            'invitee_reward_points.min' => 'Invitee reward points cannot be negative',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->update($params));
    }
}
