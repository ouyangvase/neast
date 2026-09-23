<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use Hyperf\Contract\ConfigInterface;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 用户端公开配置（免 token）
 */
#[Controller(prefix: '/app/config')]
class Config extends AbstractController
{
    #[Inject]
    protected ConfigInterface $config;

    #[RequestMapping(path: '', methods: ['GET'])]
    public function show(): ResponseInterface
    {
        return $this->success([
            'show_alpha_notice' => filter_var(
                env('SHOW_ALPHA_NOTICE_USER', false),
                FILTER_VALIDATE_BOOLEAN
            ),
            'payment_processing_fees' => $this->config->get('payment.processing_fees', []),
            'payment_h5_base_url' => payment_h5_base_url(),
        ]);
    }
}
