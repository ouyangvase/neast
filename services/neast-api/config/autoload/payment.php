<?php

declare(strict_types=1);

return [
    'processing_fees' => [
        'fpx' => 0,
        'tng' => 1.8,
        'grab' => 1.6,
        'visa' => 3.5,
    ],
    'h5_base_url' => rtrim((string) env('PAYMENT_H5_BASE_URL', env('APP_URL', '')), '/'),
];
