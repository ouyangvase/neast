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
            'code.required' => 'Voucher code is required',
            'code.string' => 'Invalid voucher code',
            'code.min' => 'Invalid voucher code',
            'code.max' => 'Invalid voucher code',
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
            'code.required' => 'Voucher code is required',
            'code.string' => 'Invalid voucher code',
            'code.min' => 'Invalid voucher code',
            'code.max' => 'Invalid voucher code',
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
}
