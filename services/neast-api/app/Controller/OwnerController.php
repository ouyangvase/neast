<?php

declare(strict_types=1);

namespace App\Controller;

use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端 App 下载 H5 落地页
 */
#[Controller(prefix: '/owner')]
class OwnerController extends AbstractController
{
    #[RequestMapping(path: '', methods: ['GET'])]
    public function index(): ResponseInterface
    {
        $templatePath = BASE_PATH . '/storage/html/owner.html';
        if (! is_file($templatePath)) {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $html = (string) file_get_contents($templatePath);
        $html = str_replace(
            ['__APP_STORE_BUTTON__', '__GOOGLE_PLAY_BUTTON__'],
            [
                $this->renderStoreButton(
                    (string) env('OWNER_APP_STORE_URL', ''),
                    'Download on the App Store',
                    'store-btn--apple',
                ),
                $this->renderStoreButton(
                    (string) env('OWNER_GOOGLE_PLAY_URL', ''),
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

    private function renderStoreButton(string $url, string $label, string $variantClass): string
    {
        $url = trim($url);
        $safeLabel = htmlspecialchars($label, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        if ($url === '') {
            return sprintf(
                '<button type="button" class="store-btn %s store-btn--disabled" disabled>%s · Coming soon</button>',
                $variantClass,
                $safeLabel,
            );
        }

        $safeUrl = htmlspecialchars($url, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        return sprintf(
            '<a href="%s" class="store-btn %s" target="_blank" rel="noopener noreferrer">%s</a>',
            $safeUrl,
            $variantClass,
            $safeLabel,
        );
    }
}
