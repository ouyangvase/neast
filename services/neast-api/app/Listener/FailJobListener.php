<?php

declare(strict_types=1);

namespace App\Listener;

use Hyperf\AsyncQueue\Event\FailedHandle;
use Hyperf\Event\Annotation\Listener;
use Hyperf\Event\Contract\ListenerInterface;
use Hyperf\DbConnection\Db;

#[Listener]
class FailJobListener implements ListenerInterface
{
    public function listen(): array
    {
        return [
            FailedHandle::class,
        ];
    }

    /**
     * @param FailedHandle $event
     */
    public function process(object $event): void
    {
        $job = $event->getMessage()->job();
        $throwable = $event->getThrowable();

        $properties = get_object_vars($job);

        Db::table('failed_jobs')->insert([
            'job_class' => get_class($job),
            'queue'     => 'default',
            'payload'   => serialize($job),
            'data_json' => json_encode($properties ?? [], JSON_UNESCAPED_UNICODE),
            'exception' => (string)$throwable,
            'failed_at' => date('Y-m-d H:i:s'),
        ]);
    }
}