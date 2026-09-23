<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Exception\AppException;
use App\Service\RewardTierService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 奖励等级维护（固定 5 档）
 */
#[Controller(prefix: '/admin/reward-tier')]
#[Middleware(AdminAuthMiddleware::class)]
class RewardTier extends AbstractController
{
    #[Inject]
    protected RewardTierService $service;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(): ResponseInterface
    {
        return $this->success($this->service->adminList());
    }

    #[RequestMapping(path: 'update', methods: ['PUT'])]
    public function update(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();
        $items = $params['items'] ?? null;

        if (! is_array($items)) {
            return $this->error('Items is required');
        }

        $rules = [
            'items' => 'required|array|size:' . RewardTierService::TIER_COUNT,
            'items.*.id' => 'required|integer|min:1|max:' . RewardTierService::TIER_COUNT,
            'items.*.name' => 'required|string|max:64',
            'items.*.min_points' => 'required|integer|min:0',
            'items.*.max_points' => 'required|integer|min:0',
        ];

        $validator = di(ValidatorFactory::class)->make(['items' => $items], $rules, [
            'items.required' => 'Please provide reward tiers',
            'items.size' => 'Reward tiers must contain exactly ' . RewardTierService::TIER_COUNT . ' records',
            'items.*.id.required' => 'Tier id is required',
            'items.*.name.required' => 'Tier name is required',
            'items.*.name.max' => 'Tier name is too long',
            'items.*.min_points.required' => 'Min points is required',
            'items.*.min_points.integer' => 'Min points must be an integer',
            'items.*.max_points.required' => 'Max points is required',
            'items.*.max_points.integer' => 'Max points must be an integer',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        try {
            return $this->success($this->service->adminUpdateAll($items));
        } catch (AppException $exception) {
            return $this->error($exception->getMessage());
        }
    }
}
