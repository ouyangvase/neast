<?php

declare(strict_types=1);

namespace App\Process;

use Hyperf\AsyncQueue\Process\ConsumerProcess;

class MerchantPushConsumerProcess extends ConsumerProcess
{
    protected string $queue = 'merchant_push';
}
