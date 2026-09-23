<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\MerchantBalanceLogService;
use App\Service\MerchantBillService;
use App\Service\MerchantPointsLogService;
use App\Service\MerchantService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家管理
 */
#[Controller(prefix: '/admin/merchant')]
#[Middleware(AdminAuthMiddleware::class)]
class Merchant extends AbstractController
{
    #[Inject]
    protected MerchantService $service;

    #[Inject]
    protected MerchantBalanceLogService $balanceLogService;

    #[Inject]
    protected MerchantPointsLogService $pointsLogService;

    #[Inject]
    protected MerchantBillService $billService;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->service->list($request));
    }

    #[RequestMapping(path: 'options', methods: ['GET'])]
    public function options(): ResponseInterface
    {
        return $this->success($this->service->options());
    }

    #[RequestMapping(path: 'bills', methods: ['GET'])]
    public function billList(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->billService->list($request));
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

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:128',
            'category_id' => 'nullable|integer|min:1',
            'address' => 'required|string|max:255',
            'password' => 'required|string|min:6|max:64',
            'contact_name' => 'required|string|max:64',
            'contact_phone' => 'required|string|max:32',
            'email' => 'required|email|max:128',
            'phone' => 'nullable|string|max:32',
            'contact_email' => 'nullable|email|max:128',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'registration_number' => 'nullable|string|max:512',
            'registration_no' => 'nullable|string|max:64',
            'points_per_rm' => 'required|integer|gt:0',
            'image' => 'nullable|string|max:512',
            'status' => 'nullable|in:0,1',
            'is_recommended' => 'nullable|in:0,1',
        ], $this->merchantCreateMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->create($params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:128',
            'category_id' => 'nullable|integer|min:1',
            'address' => 'required|string|max:255',
            'password' => 'nullable|string|min:6|max:64',
            'contact_name' => 'required|string|max:64',
            'contact_phone' => 'required|string|max:32',
            'email' => 'required|email|max:128',
            'phone' => 'nullable|string|max:32',
            'contact_email' => 'nullable|email|max:128',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'registration_number' => 'nullable|string|max:512',
            'registration_no' => 'nullable|string|max:64',
            'points_per_rm' => 'required|integer|gt:0',
            'image' => 'nullable|string|max:512',
            'status' => 'nullable|in:0,1',
            'is_recommended' => 'nullable|in:0,1',
        ], $this->merchantUpdateMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->update($id, $params));
    }

    private function merchantCommonMessages(): array
    {
        return [
            'name.required' => 'Please enter the merchant name',
            'name.max' => 'The merchant name must be less than 128 characters',
            'address.required' => 'Please enter the address',
            'address.max' => 'The address must be less than 255 characters',
            'contact_name.required' => 'Please enter the contact name',
            'contact_name.max' => 'The contact name must be less than 64 characters',
            'contact_phone.required' => 'Please enter the contact phone',
            'contact_phone.max' => 'The contact phone must be less than 32 characters',
            'email.required' => 'Please enter the email',
            'email.email' => 'Email address is invalid',
            'email.max' => 'The email must be less than 128 characters',
            'phone.max' => 'The phone number must be less than 32 characters',
            'contact_email.email' => 'Contact email address is invalid',
            'contact_email.max' => 'The contact email must be less than 128 characters',
            'latitude.numeric' => 'Latitude must be a number',
            'longitude.numeric' => 'Longitude must be a number',
            'registration_number.max' => 'The registration file path must be less than 512 characters',
            'registration_no.max' => 'The registration number must be less than 64 characters',
            'points_per_rm.required' => 'Please enter points per RM commission',
            'points_per_rm.integer' => 'Points per RM commission must be an integer',
            'points_per_rm.gt' => 'Points per RM commission must be greater than 0',
            'image.max' => 'The image path must be less than 512 characters',
        ];
    }

    private function merchantCreateMessages(): array
    {
        return array_merge($this->merchantCommonMessages(), [
            'password.required' => 'Please enter the password',
            'password.min' => 'The password must be at least 6 characters',
            'password.max' => 'The password must be less than 64 characters',
        ]);
    }

    private function merchantUpdateMessages(): array
    {
        return array_merge($this->merchantCommonMessages(), [
            'password.min' => 'The password must be at least 6 characters',
            'password.max' => 'The password must be less than 64 characters',
        ]);
    }

    #[RequestMapping(path: 'id/{id}/balance-logs', methods: ['GET'])]
    public function balanceLogs(int $id, RequestInterface $request): ResponseInterface
    {
        return $this->success($this->balanceLogService->listByMerchant($id, $request));
    }

    #[RequestMapping(path: 'id/{id}/points-logs', methods: ['GET'])]
    public function pointsLogs(int $id, RequestInterface $request): ResponseInterface
    {
        return $this->success($this->pointsLogService->listByMerchant($id, $request));
    }

    #[RequestMapping(path: 'id/{id}/bills', methods: ['GET'])]
    public function bills(int $id, RequestInterface $request): ResponseInterface
    {
        return $this->success($this->billService->listByMerchant($id, $request));
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

    #[RequestMapping(path: 'id/{id}/recommended', methods: ['PUT'])]
    public function recommended(int $id, RequestInterface $request): ResponseInterface
    {
        $isRecommended = (int) $request->input('is_recommended', 0);
        $this->service->toggleRecommended($id, $isRecommended);

        return $this->success();
    }
}
