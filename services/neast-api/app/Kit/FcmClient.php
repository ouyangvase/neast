<?php

declare(strict_types=1);

namespace App\Kit;

use Exception;
use Hyperf\Guzzle\CoroutineHandler;
use Kreait\Firebase\Contract\Messaging;
use Kreait\Firebase\Exception\MessagingException;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Http\HttpClientOptions;
use Kreait\Firebase\Messaging\AndroidConfig;
use Kreait\Firebase\Messaging\ApnsConfig;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FcmClient
{
    private Messaging $messaging;

    public function __construct(string $credentialsPath)
    {
        $factory = (new Factory())
            ->withServiceAccount($credentialsPath)
            ->withHttpClientOptions(self::buildHttpClientOptions());

        $this->messaging = $factory->createMessaging();
    }

    private static function buildHttpClientOptions(): HttpClientOptions
    {
        if (! extension_loaded('swoole')) {
            return HttpClientOptions::default();
        }

        return HttpClientOptions::default()->withGuzzleHandler(new CoroutineHandler());
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function send(string $token, string $title, string $body, array $data = []): array
    {
        try {
            $result = $this->messaging->send($this->buildMessage($token, $title, $body, $data));

            return [
                'success' => true,
                'message' => '推送发送成功',
                'message_id' => $result,
            ];
        } catch (MessagingException $e) {
            return [
                'success' => false,
                'message' => $this->resolveFailureMessage($e),
                'error' => $e->getMessage(),
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => '推送发送失败：' . $e->getMessage(),
                'error' => $e->getMessage(),
            ];
        }
    }

    /**
     * @param array<int, string> $tokens
     * @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    public function sendAll(array $tokens, string $title, string $body, array $data = []): array
    {
        if ($tokens === []) {
            return [
                'success' => false,
                'message' => 'Token 列表为空',
            ];
        }

        $messages = [];
        foreach ($tokens as $token) {
            $messages[] = $this->buildMessage($token, $title, $body, $data);
        }

        try {
            $report = $this->messaging->sendAll($messages);

            $successCount = $report->successes()->count();
            $failureCount = $report->failures()->count();

            $invalidTokens = [];
            $failureDetails = [];
            foreach ($report->failures() as $failure) {
                $error = $failure->error();
                $token = $failure->target()->value();
                $code = (string) $error->getCode();
                $failureDetails[] = [
                    'token' => substr($token, 0, 20) . '...',
                    'code' => $code,
                    'message' => $error->getMessage(),
                ];
                if ($code === 'invalid-argument'
                    || $code === 'registration-token-not-registered'
                    || str_contains($code, 'not-found')
                    || str_contains($code, 'invalid')) {
                    $invalidTokens[] = $token;
                }
            }

            return [
                'success' => $successCount > 0,
                'message' => "推送完成：成功 {$successCount} 条，失败 {$failureCount} 条",
                'success_count' => $successCount,
                'failure_count' => $failureCount,
                'invalid_tokens' => $invalidTokens,
                'failure_details' => $failureDetails,
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => '批量推送失败：' . $e->getMessage(),
                'error' => $e->getMessage(),
            ];
        }
    }

    /**
     * @param array<string, mixed> $data
     */
    private function buildMessage(string $token, string $title, string $body, array $data): CloudMessage
    {
        $notification = Notification::create($title, $body);

        $androidConfig = AndroidConfig::fromArray([
            'priority' => 'high',
            'notification' => [
                'sound' => 'default',
                'channel_id' => 'high_importance_channel',
                'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
            ],
        ]);

        $apnsConfig = ApnsConfig::fromArray([
            'headers' => [
                'apns-priority' => '10',
                'apns-push-type' => 'alert',
            ],
            'payload' => [
                'aps' => [
                    'sound' => 'default',
                    'badge' => 1,
                    'alert' => [
                        'title' => $title,
                        'body' => $body,
                    ],
                ],
            ],
        ]);

        return CloudMessage::withTarget('token', $token)
            ->withNotification($notification)
            ->withData($this->normalizeData($data))
            ->withAndroidConfig($androidConfig)
            ->withApnsConfig($apnsConfig);
    }

    /**
     * @param array<string, mixed> $data
     * @return array<string, string>
     */
    private function normalizeData(array $data): array
    {
        $normalized = [];
        foreach ($data as $key => $value) {
            if (is_scalar($value) || $value === null) {
                $normalized[(string) $key] = (string) $value;
            } else {
                $normalized[(string) $key] = json_encode($value, JSON_UNESCAPED_UNICODE) ?: '';
            }
        }

        return $normalized;
    }

    private function resolveFailureMessage(MessagingException $exception): string
    {
        $class = $exception::class;

        if ($class === 'Kreait\Firebase\Exception\Messaging\InvalidArgument') {
            return 'Token 无效或已过期';
        }

        if ($class === 'Kreait\Firebase\Exception\Messaging\NotFound') {
            return 'Token 不存在';
        }

        return '推送发送失败：' . $exception->getMessage();
    }
}
