<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Service\PaymentService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端支付相关（公开接口）
 */
#[Controller(prefix: '/app/payment')]
class Payment extends AbstractController
{
    #[Inject]
    protected PaymentService $service;

    /**
     * 支付手续费报价
     */
    #[RequestMapping(path: 'quote', methods: ['GET'])]
    public function quote(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'amount' => 'required|numeric|min:0.01',
        ], [
            'amount.required' => 'Amount is required',
            'amount.numeric' => 'Invalid amount',
            'amount.min' => 'Amount must be greater than 0',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->quote((float) $request->input('amount')));
    }
}
