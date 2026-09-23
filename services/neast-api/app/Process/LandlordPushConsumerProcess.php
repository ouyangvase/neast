<?php

declare(strict_types=1);

namespace App\Process;

use Hyperf\AsyncQueue\Process\ConsumerProcess;

class LandlordPushConsumerProcess extends ConsumerProcess
{
    protected string $queue = 'landlord_push';
}
