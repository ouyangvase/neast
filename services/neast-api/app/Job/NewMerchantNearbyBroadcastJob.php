<?php

declare(strict_types=1);

namespace App\Job;

use App\Service\FcmService;
use App\Service\MessageService;
use App\Service\PushIndexService;
use App\Service\UserLocationService;
use Hyperf\AsyncQueue\Job;
use Hyperf\Logger\LoggerFactory;
use Psr\Log\LoggerInterface;

class NewMerchantNearbyBroadcastJob extends Job
{
    private const BATCH_SIZE = 500;

    private const PUSH_INDEX = 'new_merchant_nearby';

    private const RADIUS_KM = 20.0;

    protected int $maxAttempts = 2;

    public function __construct(
        public int $merchantId,
        public float $latitude,
        public float $longitude
    ) {
    }

    public function handle(): void
    {
        $payload = di(PushIndexService::class)->resolve('user', self::PUSH_INDEX);
        if ($payload === null) {
            return;
        }

        $logger = $this->logger();
        $locationService = di(UserLocationService::class);
        $messageService = di(MessageService::class);
        $fcmService = di(FcmService::class);

        $data = [
            'type' => self::PUSH_INDEX,
            'merchant_id' => $this->merchantId,
        ];

        $offset = 0;
        $totalUsers = 0;
        $totalFcmSuccess = 0;

        while (true) {
            $batch = $locationService->findUsersWithinRadius(
                $this->latitude,
                $this->longitude,
                self::RADIUS_KM,
                self::BATCH_SIZE,
                null,
                $offset
            );

            if ($batch === []) {
                break;
            }

            $userIds = array_map(static fn (array $item): int => (int) $item['id'], $batch);
            $totalUsers += count($userIds);

            $messageService->createUserMessagesBatch(
                $userIds,
                $payload['topic'],
                $payload['content']
            );

            $result = $fcmService->sendToUsers(
                $userIds,
                $payload['topic'],
                $payload['content'],
                $data
            );

            $totalFcmSuccess += (int) ($result['success_count'] ?? 0);

            $logger->info('新商家附近用户推送批次完成', [
                'merchant_id' => $this->merchantId,
                'offset' => $offset,
                'batch_users' => count($userIds),
                'fcm_success' => $result['success_count'] ?? 0,
                'fcm_failure' => $result['failure_count'] ?? 0,
                'fcm_message' => $result['message'] ?? '',
            ]);

            if (count($batch) < self::BATCH_SIZE) {
                break;
            }

            $offset += self::BATCH_SIZE;
        }

        $logger->info('新商家附近用户推送全部完成', [
            'merchant_id' => $this->merchantId,
            'total_users' => $totalUsers,
            'total_fcm_success' => $totalFcmSuccess,
        ]);
    }

    private function logger(): LoggerInterface
    {
        return di(LoggerFactory::class)->get('fcm');
    }
}
