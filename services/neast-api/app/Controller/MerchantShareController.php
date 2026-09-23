<?php

declare(strict_types=1);

namespace App\Controller;

use App\Controller\Concerns\RendersH5StoreButtons;
use App\Model\MerchantModel;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 商家分享 H5 落地页
 */
#[Controller(prefix: '/merchant')]
class MerchantShareController extends AbstractController
{
    use RendersH5StoreButtons;

    #[RequestMapping(path: '{id:\d+}', methods: ['GET'])]
    public function show(int $id): ResponseInterface
    {
        if ($id < 1) {
            return $this->notFoundHtml();
        }

        $merchant = MerchantModel::query()
            ->where('id', $id)
            ->where('status', 1)
            ->first(['id', 'name', 'address', 'image']);

        if (! $merchant) {
            return $this->notFoundHtml();
        }

        $templatePath = BASE_PATH . '/storage/html/merchant_share.html';
        if (! is_file($templatePath)) {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $deepLink = sprintf('neastuser://merchant/%d', $merchant->id);
        $imageUrl = $merchant->image !== ''
            ? (str_starts_with($merchant->image, 'http')
                ? $merchant->image
                : rtrim((string) env('APP_URL', ''), '/') . $merchant->image)
            : '';

        $html = (string) file_get_contents($templatePath);
        $html = str_replace(
            [
                '__MERCHANT_NAME__',
                '__MERCHANT_ADDRESS__',
                '__MERCHANT_IMAGE__',
                '__DEEP_LINK__',
                '__OPEN_APP_BUTTON__',
                '__APP_STORE_BUTTON__',
                '__GOOGLE_PLAY_BUTTON__',
            ],
            [
                htmlspecialchars((string) $merchant->name, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'),
                htmlspecialchars((string) $merchant->address, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'),
                htmlspecialchars($imageUrl, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'),
                htmlspecialchars($deepLink, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'),
                $this->renderOpenAppButton($deepLink),
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

    private function notFoundHtml(): ResponseInterface
    {
        return $this->response
            ->raw('<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Merchant not found</title></head><body style="font-family:-apple-system,BlinkMacSystemFont,sans-serif;padding:24px;text-align:center;color:#0851AA;"><h1>Merchant not found</h1><p>This merchant may no longer be available.</p></body></html>')
            ->withHeader('Content-Type', 'text/html; charset=utf-8')
            ->withStatus(404);
    }
}
