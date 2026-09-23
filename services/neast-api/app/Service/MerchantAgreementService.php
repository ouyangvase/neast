<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\MerchantAgreementModel;

class MerchantAgreementService extends AbstractAgreementService
{
    protected function getModelClass(): string
    {
        return MerchantAgreementModel::class;
    }
}
