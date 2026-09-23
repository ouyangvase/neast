<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Middleware\AppOptionalAuthMiddleware;
use App\Service\CouponService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端优惠券
 */
#[Controller(prefix: '/app/coupon')]
class Coupon extends AbstractController
{
    #[Inject]
    protected CouponService $service;

    /**
     * 优惠券分类列表
     */
    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'categories', methods: ['GET'])]
    public function categories(): ResponseInterface
    {
        return $this->success($this->service->appCategories());
    }

    /**
     * 优惠券列表（可按 category_id 筛选）
     */
    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $userId = $auth ? (int) $auth->id : 0;
        $categoryId = $request->input('category_id');
        $categoryId = $categoryId !== null && $categoryId !== ''
            ? (int) $categoryId
            : null;
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 10);
        $limit = $limit > 0 ? $limit : 10;

        return $this->success($this->service->appList(
            $userId,
            $categoryId,
            $page,
            $limit
        ));
    }

    /**
     * 商家可用优惠券列表
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'merchant-list', methods: ['GET'])]
    public function merchantList(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'merchant_id' => 'required|integer|min:1',
        ], [
            'merchant_id.required' => 'Merchant is required',
            'merchant_id.integer' => 'Invalid merchant',
            'merchant_id.min' => 'Invalid merchant',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->service->appListByMerchant(
            (int) $auth->id,
            (int) $request->input('merchant_id')
        ));
    }

    /**
     * 我的未使用优惠券数量
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'my-count', methods: ['GET'])]
    public function myCount(): ResponseInterface
    {
        $auth = Context::get('app_auth');

        return $this->success($this->service->appMyCount((int) $auth->id));
    }

    /**
     * 我的未使用优惠券列表
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'my-list', methods: ['GET'])]
    public function myList(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 10);
        $limit = $limit > 0 ? $limit : 10;

        return $this->success($this->service->appMyList(
            (int) $auth->id,
            $page,
            $limit,
            (string) $request->input('status', 'active')
        ));
    }

    /**
     * 最新优惠券（首页 Featured 展示）
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'latest', methods: ['GET'])]
    public function latest(): ResponseInterface
    {
        return $this->success($this->service->appLatest());
    }

    /**
     * 兑换优惠券
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'redeem', methods: ['POST'])]
    public function redeem(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'coupon_id' => 'required|integer|min:1',
        ], [
            'coupon_id.required' => 'Coupon is required',
            'coupon_id.integer' => 'Invalid coupon',
            'coupon_id.min' => 'Invalid coupon',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->service->appRedeem(
            (int) $auth->id,
            (int) $request->input('coupon_id')
        ));
    }
}
