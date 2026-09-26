<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Service\RentHistoryService;
use App\Service\RentPaymentService;
use App\Service\RentService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端租金
 */
#[Controller(prefix: '/app/rent')]
class Rent extends AbstractController
{
    #[Inject]
    protected RentService $service;

    #[Inject]
    protected RentHistoryService $historyService;

    #[Inject]
    protected RentPaymentService $paymentService;

    /**
     * 租金列表
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 20);
        $limit = $limit > 0 ? $limit : 20;

        return $this->success($this->service->appList(
            (int) $auth->id,
            $page,
            $limit
        ));
    }

    /**
     * 创建租金记录
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'amount' => 'required|numeric|min:0.01',
            'file' => 'required|string|max:512',
            'paid_at' => 'required|integer|min:1|max:31',
            'first_pay_month' => 'required|date_format:Y-m',
            'lease_months' => 'required|integer|min:1',
            'property_id' => 'nullable|integer|min:1',
            'property_name' => 'nullable|string|max:128',
            'owner_name' => 'nullable|string|max:128',
            'landlord_bank' => 'required_without:property_id|string|max:128',
            'landlord_bank_account' => 'required_without:property_id|string|max:64',
            'landlord_account_name' => 'required_without:property_id|string|max:128',
        ], [
            'amount.required' => 'Rental amount is required',
            'amount.numeric' => 'Invalid rental amount',
            'amount.min' => 'Rental amount must be greater than 0',
            'file.required' => 'Tenancy agreement is required',
            'file.max' => 'File path is too long',
            'paid_at.required' => 'Pay date is required',
            'paid_at.integer' => 'Invalid pay date',
            'paid_at.min' => 'Pay date must be between 1 and 31',
            'paid_at.max' => 'Pay date must be between 1 and 31',
            'first_pay_month.required' => 'First pay month is required',
            'first_pay_month.date_format' => 'Invalid first pay month',
            'lease_months.required' => 'Lease term is required',
            'lease_months.integer' => 'Invalid lease term',
            'lease_months.min' => 'Lease term must be at least 1 month',
            'property_id.integer' => 'Invalid property',
            'property_id.min' => 'Invalid property',
            'property_name.max' => 'Property name is too long',
            'owner_name.max' => 'Owner name is too long',
            'landlord_bank.required_without' => 'Bank name is required',
            'landlord_bank.max' => 'Bank name is too long',
            'landlord_bank_account.required_without' => 'Account number is required',
            'landlord_bank_account.max' => 'Account number is too long',
            'landlord_account_name.required_without' => 'Account holder is required',
            'landlord_account_name.max' => 'Account holder is too long',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->service->appCreate(
            (int) $auth->id,
            $request->all()
        ));
    }

    /**
     * 修改未审核通过的租约
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'amount' => 'required|numeric|min:0.01',
            'file' => 'required|string|max:512',
            'paid_at' => 'required|integer|min:1|max:31',
            'first_pay_month' => 'required|date_format:Y-m',
            'lease_months' => 'required|integer|min:1',
            'property_id' => 'nullable|integer|min:1',
            'property_name' => 'nullable|string|max:128',
            'owner_name' => 'nullable|string|max:128',
            'landlord_bank' => 'required_without:property_id|string|max:128',
            'landlord_bank_account' => 'required_without:property_id|string|max:64',
            'landlord_account_name' => 'required_without:property_id|string|max:128',
        ], [
            'amount.required' => 'Rental amount is required',
            'amount.numeric' => 'Invalid rental amount',
            'amount.min' => 'Rental amount must be greater than 0',
            'file.required' => 'Tenancy agreement is required',
            'file.max' => 'File path is too long',
            'paid_at.required' => 'Pay date is required',
            'paid_at.integer' => 'Invalid pay date',
            'paid_at.min' => 'Pay date must be between 1 and 31',
            'paid_at.max' => 'Pay date must be between 1 and 31',
            'first_pay_month.required' => 'First pay month is required',
            'first_pay_month.date_format' => 'Invalid first pay month',
            'lease_months.required' => 'Lease term is required',
            'lease_months.integer' => 'Invalid lease term',
            'lease_months.min' => 'Lease term must be at least 1 month',
            'property_id.integer' => 'Invalid property',
            'property_id.min' => 'Invalid property',
            'property_name.max' => 'Property name is too long',
            'owner_name.max' => 'Owner name is too long',
            'landlord_bank.required_without' => 'Bank name is required',
            'landlord_bank.max' => 'Bank name is too long',
            'landlord_bank_account.required_without' => 'Account number is required',
            'landlord_bank_account.max' => 'Account number is too long',
            'landlord_account_name.required_without' => 'Account holder is required',
            'landlord_account_name.max' => 'Account holder is too long',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->service->appUpdate(
            (int) $auth->id,
            $id,
            $request->all()
        ));
    }

    /**
     * 通过物业 sn 查询房产信息
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'property', methods: ['GET'])]
    public function property(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'sn' => 'required|string|max:32',
        ], [
            'sn.required' => 'Property serial number is required',
            'sn.max' => 'Invalid property serial number',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $sn = trim((string) $request->input('sn', ''));

        return $this->success($this->service->appPropertyBySn($sn));
    }

    /**
     * 还款历史列表
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'history/list', methods: ['GET'])]
    public function historyList(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;
        $yearInput = $request->input('year', null);
        $year = ($yearInput !== null && $yearInput !== '') ? (int) $yearInput : null;
        $rentIdInput = $request->input('rent_id', null);
        $rentId = ($rentIdInput !== null && $rentIdInput !== '') ? (int) $rentIdInput : null;

        return $this->success($this->historyService->appList(
            (int) $auth->id,
            $page,
            $limit,
            $year,
            $rentId
        ));
    }

    /**
     * 钱包余额支付租金
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'pay/wallet', methods: ['POST'])]
    public function payByWallet(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'rent_id' => 'required|integer|min:1',
            'payment_method' => 'required|string|max:16',
        ], [
            'rent_id.required' => 'Rent is required',
            'rent_id.integer' => 'Invalid rent',
            'rent_id.min' => 'Invalid rent',
            'payment_method.required' => 'Payment method is required',
            'payment_method.max' => 'Invalid payment method',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->paymentService->payByWallet(
            (int) $auth->id,
            (int) $request->input('rent_id'),
            (string) $request->input('payment_method')
        ));
    }

    /**
     * 创建租金 H5 支付订单
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'pay/create', methods: ['POST'])]
    public function createPayOrder(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'rent_id' => 'required|integer|min:1',
            'payment_method' => 'required|string|max:16',
            'payment_channel' => 'nullable|string|max:32',
        ], [
            'rent_id.required' => 'Rent is required',
            'rent_id.integer' => 'Invalid rent',
            'rent_id.min' => 'Invalid rent',
            'payment_method.required' => 'Payment method is required',
            'payment_method.max' => 'Invalid payment method',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->paymentService->createPayOrder(
            (int) $auth->id,
            (int) $request->input('rent_id'),
            (string) $request->input('payment_method'),
            $request->input('payment_channel') !== null
                ? (string) $request->input('payment_channel')
                : null
        ));
    }

    /**
     * 保存未绑定房东的联系方式
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'id/{id}/owner-contact', methods: ['PUT'])]
    public function saveOwnerContact(int $id, RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'owner_name' => 'required|string|max:128',
            'owner_email' => 'nullable|string|max:128',
            'owner_phone' => 'nullable|string|max:32',
        ], [
            'owner_name.required' => 'Owner name is required',
            'owner_name.max' => 'Owner name is too long',
            'owner_email.max' => 'Email is too long',
            'owner_phone.max' => 'Phone is too long',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        return $this->success($this->service->appSaveOwnerContact(
            (int) $auth->id,
            $id,
            $request->all()
        ));
    }

    /**
     * 终止租约
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'id/{id}/terminate', methods: ['PUT'])]
    public function terminate(int $id, RequestInterface $request): ResponseInterface
    {
        $reason = trim((string) $request->input('reason', ''));

        $validator = di(ValidatorFactory::class)->make(
            ['reason' => $reason],
            ['reason' => 'nullable|string|max:255'],
            [
                'reason.max' => 'Reason is too long',
            ]
        );

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('app_auth');

        $this->service->appTerminate((int) $auth->id, $id, $reason);

        return $this->success();
    }
}
