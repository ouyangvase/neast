<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

$pushQueueConfig = [
    'driver' => Hyperf\AsyncQueue\Driver\RedisDriver::class,
    'redis' => [
        'pool' => 'default',
    ],
    'timeout' => 2,
    'retry_seconds' => 5,
    'handle_timeout' => 10,
    'processes' => 2,
    'concurrent' => [
        'limit' => 5,
    ],
];

return [
    'default' => [
        'driver' => Hyperf\AsyncQueue\Driver\RedisDriver::class,
        'redis' => [
            'pool' => 'default',
        ],
        'channel' => 'queue',
        'timeout' => 2,
        'retry_seconds' => 5,
        'handle_timeout' => 10,
        'processes' => 10,
        'concurrent' => [
            'limit' => 10,
        ],
    ],
    'user_push' => array_merge($pushQueueConfig, [
        'channel' => '{queue}:user_push',
    ]),
    'merchant_push' => array_merge($pushQueueConfig, [
        'channel' => '{queue}:merchant_push',
    ]),
    'landlord_push' => array_merge($pushQueueConfig, [
        'channel' => '{queue}:landlord_push',
    ]),
];
