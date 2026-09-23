<?php

declare(strict_types=1);

namespace App\Command;

use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\DbConnection\Db;
use Hyperf\AsyncQueue\Driver\DriverFactory;
use Psr\Container\ContainerInterface;
use Symfony\Component\Console\Input\InputArgument;

/**
 * 失败任务重试命令
 * * 功能描述：
 * 该命令用于从 `failed_jobs` 数据库表中提取执行失败的任务，并将其重新推入异步队列进行尝试。
 * * 执行逻辑：
 * 1. 根据传入的 ID 列表查询数据库。
 * 2. 将存储在 payload 字段中的字符串通过 PHP 反序列化还原为原始 Job 对象。
 * 3. 调用对应的 AsyncQueue 驱动，将对象重新 Push 到队列。
 * 4. 成功推入队列后，从失败记录表中删除该条目，防止重复执行。
 * * 使用示例：
 * php bin/hyperf.php job:retry 12          # 重试 ID 为 12 的任务
 * php bin/hyperf.php job:retry 12 13 14    # 批量重试 ID 为 12, 13, 14 的任务
 */
#[Command]
class JobRetryCommand extends HyperfCommand
{
    /**
     * @var ContainerInterface
     */
    protected $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
        parent::__construct('job:retry');
    }

    /**
     * 配置命令参数
     */
    public function configure()
    {
        parent::configure();
        $this->setDescription('从 failed_jobs 表中提取并重新投递失败的任务');
        
        // 允许传入多个 ID，IS_ARRAY 模式会自动将参数转化为数组
        $this->addArgument(
            'id', 
            InputArgument::IS_ARRAY | InputArgument::REQUIRED, 
            '需要重试的任务 ID (支持多个)'
        );
    }

    /**
     * 命令执行主入口
     */
    public function handle()
    {
        // 1. 获取命令行传入的 ID 数组
        $ids = $this->input->getArgument('id');
        
        /** @var DriverFactory $driverFactory */
        $driverFactory = $this->container->get(DriverFactory::class);

        // 2. 从数据库中检索这些记录
        $jobs = Db::table('failed_jobs')->whereIn('id', $ids)->get();

        if ($jobs->isEmpty()) {
            $this->error("未发现匹配的任务记录，请检查 ID 是否正确。");
            return;
        }

        $this->line("开始尝试恢复 " . $jobs->count() . " 个任务...");

        foreach ($jobs as $record) {
            try {
                // 3. 反序列化
                // payload 存储的是整个 Job 对象的二进制序列化字符串
                $job = unserialize($record->payload);

                if (!$job) {
                    throw new \RuntimeException("无法解析 ID 为 [{$record->id}] 的 payload。");
                }
                
                // 4. 获取任务当初所属的队列驱动 (默认为 default)
                $queueName = $record->queue ?? 'default';
                $driver = $driverFactory->get($queueName);
                
                // 5. 重新投递到异步队列
                $driver->push($job);

                // 6. 关键：成功入队后必须物理删除失败记录，避免后续维护混乱
                Db::table('failed_jobs')->where('id', $record->id)->delete();

                $this->info("成功：任务 ID [{$record->id}] ({$record->job_class}) 已回到队列。");

            } catch (\Throwable $e) {
                // 捕获异常，防止其中一个任务失败导致整个批量重试命令中断
                $this->error("失败：任务 ID [{$record->id}] 恢复过程中发生错误：{$e->getMessage()}");
            }
        }

        $this->line("操作执行完毕。");
    }
}