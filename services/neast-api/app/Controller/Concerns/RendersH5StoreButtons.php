<?php

declare(strict_types=1);

namespace App\Controller\Concerns;

trait RendersH5StoreButtons
{
    protected function renderStoreButton(string $url, string $label, string $variantClass): string
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

    protected function renderOpenAppButton(string $deepLink): string
    {
        $safeUrl = htmlspecialchars(trim($deepLink), ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        return sprintf(
            '<a href="%s" class="store-btn store-btn--open-app">Open in neast app</a>',
            $safeUrl,
        );
    }
}
