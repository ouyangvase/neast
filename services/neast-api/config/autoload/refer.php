<?php

declare(strict_types=1);

use function Hyperf\Support\env;

return [
    'invite_url' => env('REFERR_INVITE_URL', ''),
];
