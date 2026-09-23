<?php

declare(strict_types=1);

namespace App\Command;

use App\Service\MerchantBillGenerateService;
use Hyperf\Command\Annotation\Command;
use Hyperf\Command\Command as HyperfCommand;
use Psr\Container\ContainerInterface;
use Symfony\Component\Console\Input\InputOption;

#[Command]
class MerchantBillGenerateCommand extends HyperfCommand
{
    public function __construct(
        protected ContainerInterface $container,
        protected MerchantBillGenerateService $service,
    ) {
        parent::__construct('merchant-bill:generate');
    }

    public function configure()
    {
        parent::configure();
        $this->setDescription('Generate merchant settlement bills for a given month');
        $this->addOption('month', null, InputOption::VALUE_OPTIONAL, 'Bill month in YYYY-MM format');
    }

    public function handle()
    {
        $month = trim((string) $this->input->getOption('month'));
        $billMonth = $month !== '' ? $month : $this->service->resolvePreviousBillMonth();

        $stats = $this->service->generate($billMonth);

        $this->info(sprintf(
            'Bill month: %s, created: %d, skipped: %d, failed: %d',
            $stats['bill_month'],
            $stats['created'],
            $stats['skipped'],
            $stats['failed'],
        ));

        return $stats['failed'] > 0 ? self::FAILURE : self::SUCCESS;
    }
}
