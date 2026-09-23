<?php

declare(strict_types=1);

use function Hyperf\Support\env;

return [
    'merchant_id' => env('FIUU_MERCHANT_ID', 'QRneast'),
    'verify_key' => env('FIUU_VERIFY_KEY', '90af5acf5af27e119c71fdeb7037b53d'),
    'secret_key' => env('FIUU_SECRET_KEY', '52bd5ab98cb88240569b05e9ac6aea49'),
    'currency' => env('FIUU_CURRENCY', 'MYR'),
    'country' => env('FIUU_COUNTRY', 'MY'),
    'channels' => [
        'tng' => 'TNG-EWALLET',
        'grab' => 'GrabPay',
        'visa' => 'credit',
    ],
    'fpx_banks' => [
        'Affin Bank' => 'fpx_abb',
        'Alliance Bank' => 'fpx_abmb',
        'AmBank' => 'fpx_amb',
        'BSN' => 'fpx_bsn',
        'Bank Islam' => 'fpx_bimb',
        'Bank Muamalat' => 'fpx_bmmb',
        'Bank Rakyat' => 'fpx_bkrm',
        'CIMB Clicks' => 'fpx_cimbclicks',
        'HSBC Bank' => 'fpx_hsbc',
        'Hong Leong Bank' => 'fpx_hlb',
        'KFH' => 'fpx_kfh',
        'Maybank2U' => 'fpx_mb2u',
        'OCBC Bank' => 'fpx_ocbc',
        'Public Bank' => 'fpx_pbb',
        'RHB Bank' => 'fpx_rhb',
        'Standard Chartered' => 'fpx_scb',
        'UOB Bank' => 'fpx_uob',
    ],
];
