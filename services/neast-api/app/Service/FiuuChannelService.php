<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use Hyperf\Contract\ConfigInterface;

class FiuuChannelService
{
    public function __construct(private ConfigInterface $config)
    {
    }

    public function resolve(string $paymentMethod, ?string $paymentChannel = null): string
    {
        $paymentMethod = strtolower(trim($paymentMethod));

        if ($paymentMethod === 'fpx') {
            $channel = trim((string) ($paymentChannel ?? ''));
            if ($channel === '') {
                return 'fpx';
            }

            if ($channel === 'fpx') {
                return 'fpx';
            }

            /** @var array<string, string> $fpxBanks */
            $fpxBanks = $this->config->get('fiuu.fpx_banks', []);
            $allowedChannels = array_values($fpxBanks);

            if (! in_array($channel, $allowedChannels, true)) {
                throw new AppException('Invalid FPX bank');
            }

            return $channel;
        }

        /** @var array<string, string> $channels */
        $channels = $this->config->get('fiuu.channels', []);
        $channel = trim((string) ($channels[$paymentMethod] ?? ''));

        if ($channel === '') {
            throw new AppException('Unsupported payment channel');
        }

        return $channel;
    }
}
