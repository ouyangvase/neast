<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端公开配置（免 token）
 */
#[Controller(prefix: '/landlord/config')]
class Config extends AbstractController
{
    #[RequestMapping(path: '', methods: ['GET'])]
    public function show(): ResponseInterface
    {
        return $this->success([
            'show_alpha_notice' => filter_var(
                env('SHOW_ALPHA_NOTICE_LANDLORD', false),
                FILTER_VALIDATE_BOOLEAN
            ),
        ]);
    }
}
