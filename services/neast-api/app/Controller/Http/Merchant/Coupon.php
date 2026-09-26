<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Middleware\MerchantAuthMiddleware;
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
 * 商家端优惠券
 */
#[Controller(prefix: '/merchant/coupon')]
class Coupon extends AbstractController
{
    #[Inject]
    protected CouponService $service;

    /**
     * 校验优惠券（扫码 token 或手输 SN）
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'verify', methods: ['POST'])]
    public function verify(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'code' => 'required|string|min:1|max:64',
        ], [
            'code.required' => 'Coupon code is required',
            'code.string' => 'Invalid coupon code',
            'code.min' => 'Invalid coupon code',
            'code.max' => 'Invalid coupon code',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('merchant_auth');

        return $this->success($this->service->merchantVerifyByCode(
            (int) $auth->id,
            (string) $request->input('code')
        ));
    }

    /**
     * 核销优惠券（扫码 token 或手输 SN）
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'redeem', methods: ['POST'])]
    public function redeem(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'code' => 'required|string|min:1|max:64',
        ], [
            'code.required' => 'Coupon code is required',
            'code.string' => 'Invalid coupon code',
            'code.min' => 'Invalid coupon code',
            'code.max' => 'Invalid coupon code',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('merchant_auth');

        return $this->success($this->service->merchantRedeemByCode(
            (int) $auth->id,
            (string) $request->input('code')
        ));
    }

    /**
     * 提交本店优惠券，待管理员审核
     */
    #[Middleware(MerchantAuthMiddleware::class)]
    #[RequestMapping(path: 'submit', methods: ['POST'])]
    public function submit(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:128',
            'required_points' => 'required|integer|min:1',
            'valid_days' => 'required|integer|min:1',
            'discount_amount' => 'required|numeric|min:0',
            'usage_condition' => 'nullable|string',
            'redeem_limit' => 'nullable|integer|min:1',
            'category_id' => 'required|integer|min:1',
            'image' => 'nullable|string|max:512',
        ], [
            'name.required' => 'Please enter the coupon name',
            'name.max' => 'The coupon name must be less than 128 characters',
            'required_points.required' => 'Please enter required points',
            'required_points.min' => 'Required points must be at least 1',
            'valid_days.required' => 'Please enter valid days',
            'valid_days.min' => 'Valid days must be at least 1',
            'discount_amount.required' => 'Please enter discount amount',
            'discount_amount.min' => 'Discount amount must be at least 0',
            'redeem_limit.min' => 'Redeem limit must be at least 1',
            'category_id.required' => 'Please select a category',
            'category_id.min' => 'Please select a category',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('merchant_auth');

        return $this->success($this->service->merchantSubmit((int) $auth->id, $params));
    }
}
