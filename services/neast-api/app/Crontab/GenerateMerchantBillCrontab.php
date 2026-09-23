<?php

declare(strict_types=1);

namespace App\Crontab;

use App\Service\MerchantBillGenerateService;
use Hyperf\Crontab\Annotation\Crontab;
use Hyperf\Di\Annotation\Inject;
use Hyperf\Logger\LoggerFactory;
use Psr\Log\LoggerInterface;

#[Crontab(
    rule: '0 0 3 * *',
    name: 'GenerateMerchantBill',
    callback: 'execute',
    memo: '每月3号生成上月商家账单',
)]
class GenerateMerchantBillCrontab
{
    #[Inject]
    protected MerchantBillGenerateService $service;

    private LoggerInterface $logger;

    public function __construct(LoggerFactory $loggerFactory)
    {
        $this->logger = $loggerFactory->get('merchant-bill');
    }

    public function execute(): void
    {
        $billMonth = $this->service->resolvePreviousBillMonth();
        $stats = $this->service->generate($billMonth);

        $this->logger->info('Merchant bill generation finished', $stats);
    }
}
