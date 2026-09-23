<?php

declare(strict_types=1);

namespace App\Service;

use App\Kit\FcmClient;
use App\Model\LandlordFcmTokenModel;
use App\Model\MerchantFcmTokenModel;
use App\Model\UserFcmTokenModel;
use Exception;
use Hyperf\Contract\ConfigInterface;
use Hyperf\Logger\LoggerFactory;
use Psr\Log\LoggerInterface;

class FcmService
{
    private FcmClient $fcmClient;

    private LoggerInterface $logger;

    private UserFcmTokenService $userFcmTokenService;

    private MerchantFcmTokenService $merchantFcmTokenService;

    private LandlordFcmTokenService $landlordFcmTokenService;

    public function __construct(
        LoggerFactory $loggerFactory,
        ConfigInterface $config,
        UserFcmTokenService $userFcmTokenService,
        MerchantFcmTokenService $merchantFcmTokenService,
        LandlordFcmTokenService $landlordFcmTokenService
    ) {
        $this->logger = $loggerFactory->get('fcm');
        $this->userFcmTokenService = $userFcmTokenService;
        $this->merchantFcmTokenService = $merchantFcmTokenService;
        $this->landlordFcmTokenService = $landlordFcmTokenService;

        $credentials = (string) $config->get('firebase.credentials', 'storage/firebase-credentials.json');
        $path = BASE_PATH . '/' . ltrim($credentials, '/');

        try {
            $this->fcmClient = new FcmClient($path);
        } catch (Exception $e) {
            $this->logger->error('Firebase 初始化失败: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function sendToToken(string $token, string $title, string $body, array $data = []): array
    {
        $result = $this->fcmClient->send($token, $title, $body, $data);

        if ($result['success'] ?? false) {
            $this->logger->info('推送发送成功', [
                'token' => substr($token, 0, 20) . '...',
                'title' => $title,
                'message_id' => $result['message_id'] ?? null,
            ]);

            return $result;
        }

        $this->logger->error('推送发送失败', [
            'token' => substr($token, 0, 20) . '...',
            'error' => $result['error'] ?? $result['message'] ?? '',
        ]);

        return $result;
    }

    /**
     * @param array<int, string> $tokens
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function sendToMultiple(
        array $tokens,
        string $title,
        string $body,
        array $data = [],
        ?callable $invalidTokenCleaner = null
    ): array {
        $result = $this->fcmClient->sendAll($tokens, $title, $body, $data);

        if (! ($result['success'] ?? false)) {
            $this->logger->error('批量推送失败', [
                'error' => $result['error'] ?? $result['message'] ?? '',
                'failure_details' => $result['failure_details'] ?? [],
            ]);

            return $result;
        }

        $invalidTokens = $result['invalid_tokens'] ?? [];
        if (is_array($invalidTokens) && $invalidTokens !== []) {
            if ($invalidTokenCleaner !== null) {
                $invalidTokenCleaner($invalidTokens);
            } else {
                $this->userFcmTokenService->removeInvalidTokens($invalidTokens);
            }
        }

        if (($result['failure_count'] ?? 0) > 0) {
            $this->logger->warning('批量推送部分失败', [
                'failure_details' => $result['failure_details'] ?? [],
            ]);
        }

        $this->logger->info('批量推送完成', [
            'total' => count($tokens),
            'success' => $result['success_count'] ?? 0,
            'failure' => $result['failure_count'] ?? 0,
            'invalid_tokens' => is_array($invalidTokens) ? count($invalidTokens) : 0,
        ]);

        return $result;
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function sendToUser(int $userId, string $title, string $body, array $data = []): array
    {
        $tokens = UserFcmTokenModel::query()
            ->where('user_id', $userId)
            ->pluck('token')
            ->unique()
            ->values()
            ->all();

        if ($tokens === []) {
            return [
                'success' => false,
                'message' => '用户没有 FCM Token',
            ];
        }

        return $this->sendToMultiple($tokens, $title, $body, $data);
    }

    /**
     * @param array<int, int> $userIds
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function sendToUsers(array $userIds, string $title, string $body, array $data = []): array
    {
        $userIds = array_values(array_unique(array_filter(
            $userIds,
            static fn (int $userId): bool => $userId > 0
        )));

        if ($userIds === []) {
            return [
                'success' => false,
                'message' => '用户 ID 列表为空',
            ];
        }

        $tokens = UserFcmTokenModel::query()
            ->whereIn('user_id', $userIds)
            ->pluck('token')
            ->unique()
            ->values()
            ->all();

        if ($tokens === []) {
            return [
                'success' => false,
                'message' => '无 FCM Token',
            ];
        }

        return $this->sendToMultiple(
            $tokens,
            $title,
            $body,
            $data,
            fn (array $invalidTokens) => $this->userFcmTokenService->removeInvalidTokens($invalidTokens)
        );
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function sendToMerchant(int $merchantId, string $title, string $body, array $data = []): array
    {
        $tokens = MerchantFcmTokenModel::query()
            ->where('merchant_id', $merchantId)
            ->pluck('token')
            ->unique()
            ->values()
            ->all();

        if ($tokens === []) {
            return [
                'success' => false,
                'message' => '商家没有 FCM Token',
            ];
        }

        return $this->sendToMultiple(
            $tokens,
            $title,
            $body,
            $data,
            fn (array $invalidTokens) => $this->merchantFcmTokenService->removeInvalidTokens($invalidTokens)
        );
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function sendToLandlord(int $landlordId, string $title, string $body, array $data = []): array
    {
        $tokens = LandlordFcmTokenModel::query()
            ->where('landlord_id', $landlordId)
            ->pluck('token')
            ->unique()
            ->values()
            ->all();

        if ($tokens === []) {
            return [
                'success' => false,
                'message' => '房东没有 FCM Token',
            ];
        }

        return $this->sendToMultiple(
            $tokens,
            $title,
            $body,
            $data,
            fn (array $invalidTokens) => $this->landlordFcmTokenService->removeInvalidTokens($invalidTokens)
        );
    }
}
