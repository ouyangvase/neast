<?php

declare(strict_types=1);

namespace App\Service;

use Hyperf\Contract\ConfigInterface;

class PushIndexService
{
    public function __construct(private ConfigInterface $config)
    {
    }

    /**
     * @return array{topic: string, content: string}|null
     */
    public function resolve(string $audience, string $index): ?array
    {
        $item = $this->config->get("push_index.{$audience}.{$index}");

        if (! is_array($item)) {
            return null;
        }

        $topic = trim((string) ($item['topic'] ?? ''));
        $content = trim((string) ($item['content'] ?? ''));

        if ($topic === '' || $content === '') {
            return null;
        }

        return [
            'topic' => $topic,
            'content' => $content,
        ];
    }

    public function exists(string $audience, string $index): bool
    {
        return $this->resolve($audience, $index) !== null;
    }
}
