<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\RentHistoryService;
use App\Service\RentService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 租金管理
 */
#[Controller(prefix: '/admin/rent')]
#[Middleware(AdminAuthMiddleware::class)]
class Rent extends AbstractController
{
    #[Inject]
    protected RentService $service;

    #[Inject]
    protected RentHistoryService $historyService;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->service->list($request));
    }

    #[RequestMapping(path: 'property-options', methods: ['GET'])]
    public function propertyOptions(): ResponseInterface
    {
        return $this->success($this->service->propertyOptions());
    }

    #[RequestMapping(path: 'id/{id}/payment-schedule-preview', methods: ['GET'])]
    public function paymentSchedulePreview(int $id): ResponseInterface
    {
        return $this->success($this->service->paymentSchedulePreview($id));
    }

    #[RequestMapping(path: 'id/{id}/audit', methods: ['PUT'])]
    public function audit(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();
        $result = trim((string) ($params['result'] ?? ''));

        $rules = [
            'result' => 'required|in:approved,rejected',
        ];

        if ($result === 'approved') {
            $rules['landlord_bank'] = 'nullable|string|max:128';
            $rules['landlord_bank_account'] = 'nullable|string|max:64';
            $rules['landlord_account_name'] = 'nullable|string|max:128';
            $rules['property_id'] = 'nullable|integer|min:1';
        }

        $validator = di(ValidatorFactory::class)->make($params, $rules, [
            'result.required' => 'Please select a review result',
            'result.in' => 'Invalid review result',
            'landlord_bank.max' => 'Landlord bank is too long',
            'landlord_bank_account.max' => 'Landlord bank account is too long',
            'landlord_account_name.max' => 'Landlord account name is too long',
            'property_id.integer' => 'Invalid property',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->service->audit($id, $params);

        return $this->success();
    }

    #[RequestMapping(path: 'id/{id}/confirm-link', methods: ['PUT'])]
    public function confirmLink(int $id): ResponseInterface
    {
        $this->service->confirmLink($id);

        return $this->success();
    }

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

        $this->service->terminate($id, $reason);

        return $this->success();
    }

    #[RequestMapping(path: 'history/list', methods: ['GET'])]
    public function historyList(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->historyService->list($request));
    }

    #[RequestMapping(path: 'history/id/{id}/settle', methods: ['PUT'])]
    public function historySettle(int $id, RequestInterface $request): ResponseInterface
    {
        $receipt = trim((string) $request->input('receipt', ''));

        $validator = di(ValidatorFactory::class)->make(
            ['receipt' => $receipt],
            ['receipt' => 'required|string|max:512'],
            [
                'receipt.required' => 'Please upload receipt',
                'receipt.max' => 'Receipt path is too long',
            ]
        );

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->historyService->settle($id, $receipt);

        return $this->success();
    }
}
