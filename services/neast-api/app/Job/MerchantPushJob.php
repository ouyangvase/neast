<?php

declare(strict_types=1);

namespace App\Job;

use App\Service\FcmService;
use App\Service\MessageService;
use App\Service\PushIndexService;
use Hyperf\AsyncQueue\Job;

class MerchantPushJob extends Job
{
    protected int $maxAttempts = 2;

    public function __construct(
        public int $recipientId,
        public string $index,
        public array $data = []
    ) {
    }

    public function handle(): void
    {
        $payload = di(PushIndexService::class)->resolve('merchant', $this->index);
        if ($payload === null) {
            return;
        }

        di(MessageService::class)->createMerchantMessage(
            $this->recipientId,
            $payload['topic'],
            $payload['content']
        );

        di(FcmService::class)->sendToMerchant(
            $this->recipientId,
            $payload['topic'],
            $payload['content'],
            array_merge(['type' => $this->index], $this->data)
        );
    }
}
