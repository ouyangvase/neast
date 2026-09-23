<?php

declare(strict_types=1);

use function Hyperf\Support\env;

return [
    'client_id'     => env('PAYPAL_CLIENT_ID', ''),
    'client_secret' => env('PAYPAL_CLIENT_SECRET', ''),
    'webhook_id'    => env('PAYPAL_WEBHOOK_ID', ''),
    'currency'      => env('PAYPAL_CURRENCY', 'USD'),
    'mode'          => env('PAYPAL_MODE', 'sandbox'),
];
