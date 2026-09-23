<?php

declare(strict_types=1);

namespace App\Command;

use App\Service\FcmService;
use Hyperf\Command\Annotation\Command;
use Hyperf\Command\Command as HyperfCommand;
use Psr\Container\ContainerInterface;
use Symfony\Component\Console\Input\InputOption;

#[Command]
class FcmTestCommand extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('fcm:test');
    }

    public function configure(): void
    {
        parent::configure();
        $this->setDescription('向指定用户、商家或房东发送 FCM 测试推送');
        $this->addOption('user-id', null, InputOption::VALUE_OPTIONAL, '用户 ID');
        $this->addOption('merchant-id', null, InputOption::VALUE_OPTIONAL, '商家 ID');
        $this->addOption('landlord-id', null, InputOption::VALUE_OPTIONAL, '房东 ID');
        $this->addOption('title', null, InputOption::VALUE_OPTIONAL, '通知标题', 'Test');
        $this->addOption('body', null, InputOption::VALUE_OPTIONAL, '通知内容', 'Hello from Neast');
    }

    public function handle(): void
    {
        $userId = (int) $this->input->getOption('user-id');
        $merchantId = (int) $this->input->getOption('merchant-id');
        $landlordId = (int) $this->input->getOption('landlord-id');

        $specifiedCount = ($userId > 0 ? 1 : 0) + ($merchantId > 0 ? 1 : 0) + ($landlordId > 0 ? 1 : 0);
        if ($specifiedCount !== 1) {
            $this->error('请指定 --user-id、--merchant-id 或 --landlord-id 其中之一');

            return;
        }

        $title = (string) $this->input->getOption('title');
        $body = (string) $this->input->getOption('body');

        /** @var FcmService $service */
        $service = $this->container->get(FcmService::class);

        if ($merchantId > 0) {
            $result = $service->sendToMerchant($merchantId, $title, $body, ['type' => 'Test']);
            $this->printResult($result, 'merchant');
        } elseif ($landlordId > 0) {
            $result = $service->sendToLandlord($landlordId, $title, $body, ['type' => 'Test']);
            $this->printResult($result, 'landlord');
        } else {
            $result = $service->sendToUser($userId, $title, $body, ['type' => 'Test']);
            $this->printResult($result, 'user');
        }
    }

    /**
     * @param array<string, mixed> $result
     */
    private function printResult(array $result, string $target): void
    {
        $successCount = (int) ($result['success_count'] ?? 0);
        $failureCount = (int) ($result['failure_count'] ?? 0);

        if ($successCount > 0) {
            $this->info($result['message'] ?? '推送成功');
            if (isset($result['message_id'])) {
                $this->line('message_id: ' . $result['message_id']);
            }
            $this->line('success_count: ' . $successCount);
            if ($failureCount > 0) {
                $this->line('failure_count: ' . $failureCount);
            }
        } else {
            $this->error($result['message'] ?? '推送失败');
        }

        if (isset($result['error'])) {
            $this->line('error: ' . $result['error']);
        }

        $failureDetails = $result['failure_details'] ?? [];
        if (is_array($failureDetails) && $failureDetails !== []) {
            $this->warn('失败详情:');
            foreach ($failureDetails as $detail) {
                if (! is_array($detail)) {
                    continue;
                }
                $this->line(sprintf(
                    '  - [%s] %s (%s)',
                    $detail['code'] ?? 'unknown',
                    $detail['message'] ?? '',
                    $detail['token'] ?? ''
                ));
            }
        }

        if (! empty($result['invalid_tokens'])) {
            $this->warn('invalid_tokens: ' . implode(', ', $result['invalid_tokens']));
        }

        if ($successCount === 0 && $failureCount === 0 && ! ($result['success'] ?? false)) {
            $hint = match ($target) {
                'merchant' => '请确认商家已登录 App 并成功上报 FCM Token',
                'landlord' => '请确认房东已登录 App 并成功上报 FCM Token',
                default => '请确认用户已登录 App 并成功上报 FCM Token',
            };
            $this->comment('提示: ' . $hint);
        }
    }
}
