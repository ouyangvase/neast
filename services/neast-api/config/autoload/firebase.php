<?php

declare(strict_types=1);

use function Hyperf\Support\env;

return [
    'credentials' => env('FIREBASE_CREDENTIALS', 'storage/firebase-credentials.json'),
];
