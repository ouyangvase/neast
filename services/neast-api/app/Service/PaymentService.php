<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use Hyperf\Contract\ConfigInterface;

class PaymentService
{
    public function __construct(private ConfigInterface $config)
    {
    }

    /**
     * @return array{amount: string, methods: array<string, array{fee_percent: float, total_amount: string}>}
     */
    public function quote(float $amount): array
    {
        if ($amount <= 0) {
            throw new AppException('Amount must be greater than 0');
        }

        /** @var array<string, float|int> $fees */
        $fees = $this->config->get('payment.processing_fees', []);
        $methods = [];

        foreach ($fees as $method => $feePercent) {
            $feePercent = (float) $feePercent;
            $totalAmount = round($amount * (1 + $feePercent / 100), 2);

            $methods[(string) $method] = [
                'fee_percent' => $feePercent,
                'total_amount' => $this->formatAmount($totalAmount),
            ];
        }

        return [
            'amount' => $this->formatAmount($amount),
            'methods' => $methods,
        ];
    }

    private function formatAmount(mixed $value): string
    {
        return number_format((float) $value, 2, '.', '');
    }
}
