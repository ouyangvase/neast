<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\GivePointsRecordModel;
use App\Model\MerchantBillModel;
use App\Model\MerchantModel;
use Hyperf\Logger\LoggerFactory;
use Psr\Log\LoggerInterface;
use Throwable;

class MerchantBillGenerateService
{
    private LoggerInterface $logger;

    public function __construct(LoggerFactory $loggerFactory)
    {
        $this->logger = $loggerFactory->get('merchant-bill');
    }

    /**
     * @return array{created: int, skipped: int, failed: int, bill_month: string}
     */
    public function generate(string $billMonth): array
    {
        $this->assertBillMonth($billMonth);
        [$startDate, $endDate] = $this->monthDateRange($billMonth);

        $stats = [
            'created' => 0,
            'skipped' => 0,
            'failed' => 0,
            'bill_month' => $billMonth,
        ];

        $merchants = MerchantModel::query()
            ->select(['id', 'points_per_rm'])
            ->orderBy('id')
            ->get();

        foreach ($merchants as $merchant) {
            $merchantId = (int) $merchant->id;

            try {
                $exists = MerchantBillModel::query()
                    ->where('merchant_id', $merchantId)
                    ->where('bill_month', $billMonth)
                    ->exists();

                if ($exists) {
                    ++$stats['skipped'];
                    continue;
                }

                $points = (int) GivePointsRecordModel::query()
                    ->where('merchant_id', $merchantId)
                    ->whereDate('created_at', '>=', $startDate)
                    ->whereDate('created_at', '<=', $endDate)
                    ->sum('points');

                $pointsPerRm = (int) ($merchant->points_per_rm ?? 1);
                if ($pointsPerRm <= 0) {
                    $pointsPerRm = 1;
                }

                $amount = number_format(round($points / $pointsPerRm, 2), 2, '.', '');

                MerchantBillModel::query()->create([
                    'merchant_id' => $merchantId,
                    'bill_month' => $billMonth,
                    'amount' => $amount,
                    'points' => $points,
                    'is_paid' => 0,
                    'payment_method' => '',
                ]);

                ++$stats['created'];
            } catch (Throwable $throwable) {
                ++$stats['failed'];
                $this->logger->error('Failed to generate merchant bill', [
                    'merchant_id' => $merchantId,
                    'bill_month' => $billMonth,
                    'message' => $throwable->getMessage(),
                ]);
            }
        }

        return $stats;
    }

    public function resolvePreviousBillMonth(): string
    {
        return date('Y-m', strtotime('first day of last month'));
    }

    /**
     * @return array{0: string, 1: string}
     */
    private function monthDateRange(string $billMonth): array
    {
        $this->assertBillMonth($billMonth);

        $startDate = $billMonth . '-01';
        $endDate = date('Y-m-t', strtotime($startDate));

        return [$startDate, $endDate];
    }

    private function assertBillMonth(string $billMonth): void
    {
        if (! preg_match('/^\d{4}-\d{2}$/', $billMonth)) {
            throw new AppException('Invalid bill month format');
        }
    }
}
