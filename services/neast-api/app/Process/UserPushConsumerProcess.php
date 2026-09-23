<?php

declare(strict_types=1);

namespace App\Process;

use Hyperf\AsyncQueue\Process\ConsumerProcess;

class UserPushConsumerProcess extends ConsumerProcess
{
    protected string $queue = 'user_push';
}
