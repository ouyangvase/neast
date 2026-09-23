<?php

declare(strict_types=1);

namespace App\Controller;

use App\Controller\Concerns\RendersH5StoreButtons;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 推荐邀请 H5 落地页
 */
#[Controller(prefix: '/invite')]
class InviteController extends AbstractController
{
    use RendersH5StoreButtons;

    #[RequestMapping(path: '', methods: ['GET'])]
    public function index(): ResponseInterface
    {
        $templatePath = BASE_PATH . '/storage/html/invite.html';
        if (! is_file($templatePath)) {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $html = (string) file_get_contents($templatePath);
        $html = str_replace(
            ['__APP_STORE_BUTTON__', '__GOOGLE_PLAY_BUTTON__'],
            [
                $this->renderStoreButton(
                    (string) env('APP_STORE_URL', ''),
                    'Download on the App Store',
                    'store-btn--apple',
                ),
                $this->renderStoreButton(
                    (string) env('GOOGLE_PLAY_URL', ''),
                    'Get it on Google Play',
                    'store-btn--google',
                ),
            ],
            $html,
        );

        return $this->response
            ->raw($html)
            ->withHeader('Content-Type', 'text/html; charset=utf-8');
    }
}
