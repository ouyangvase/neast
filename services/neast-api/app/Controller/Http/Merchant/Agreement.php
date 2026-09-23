<?php

declare(strict_types=1);

namespace App\Controller\Http\Merchant;

use App\Controller\AbstractController;
use App\Service\MerchantAgreementService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家端协议（公开读取）
 */
#[Controller(prefix: '/merchant/agreement')]
class Agreement extends AbstractController
{
    #[Inject]
    protected MerchantAgreementService $service;

    #[RequestMapping(path: 'detail', methods: ['GET'])]
    public function detail(RequestInterface $request): ResponseInterface
    {
        $title = trim((string) $request->input('title', ''));

        return $this->success($this->service->findByTitle($title));
    }
}
