<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\CouponService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 优惠券管理
 */
#[Controller(prefix: '/admin/coupon')]
#[Middleware(AdminAuthMiddleware::class)]
class Coupon extends AbstractController
{
    #[Inject]
    protected CouponService $service;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->service->list($request));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['GET'])]
    public function detail(int $id): ResponseInterface
    {
        return $this->success($this->service->detail($id));
    }

    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, $this->couponRules(), $this->couponMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->create($params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, $this->couponRules(), $this->couponMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->update($id, $params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['DELETE'])]
    public function delete(int $id): ResponseInterface
    {
        $this->service->delete($id);

        return $this->success();
    }

    #[RequestMapping(path: 'id/{id}/status', methods: ['PUT'])]
    public function status(int $id, RequestInterface $request): ResponseInterface
    {
        $status = (int) $request->input('status', 1);
        $this->service->toggleStatus($id, $status);

        return $this->success();
    }

    #[RequestMapping(path: 'id/{id}/review', methods: ['PUT'])]
    public function review(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'result' => 'required|in:approved,rejected',
        ], [
            'result.required' => 'Please select a review result',
            'result.in' => 'Invalid review result',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->review($id, (string) $params['result']));
    }

    private function couponRules(): array
    {
        return [
            'name' => 'required|string|max:128',
            'required_points' => 'required|integer|min:1',
            'valid_days' => 'required|integer|min:1',
            'discount_amount' => 'required|numeric|min:0',
            'usage_condition' => 'nullable|string',
            'status' => 'required|in:0,1',
            'redeem_limit' => 'nullable|integer|min:1',
            'category_id' => 'required|integer|min:1',
            'image' => 'nullable|string|max:512',
            'merchant_ids' => 'required|array|min:1',
            'merchant_ids.*' => 'integer|min:1',
        ];
    }

    private function couponMessages(): array
    {
        return [
            'name.required' => 'Please enter the coupon name',
            'name.max' => 'The coupon name must be less than 128 characters',
            'required_points.required' => 'Please enter required points',
            'required_points.min' => 'Required points must be at least 1',
            'valid_days.required' => 'Please enter valid days',
            'valid_days.min' => 'Valid days must be at least 1',
            'discount_amount.required' => 'Please enter discount amount',
            'discount_amount.min' => 'Discount amount must be at least 0',
            'status.required' => 'Please select status',
            'status.in' => 'Invalid status value',
            'redeem_limit.min' => 'Redeem limit must be at least 1',
            'category_id.required' => 'Please select a category',
            'category_id.min' => 'Please select a category',
            'merchant_ids.required' => 'Please select at least one merchant',
            'merchant_ids.min' => 'Please select at least one merchant',
        ];
    }
}
