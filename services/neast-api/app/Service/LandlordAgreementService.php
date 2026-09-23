<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\LandlordAgreementModel;

class LandlordAgreementService extends AbstractAgreementService
{
    protected function getModelClass(): string
    {
        return LandlordAgreementModel::class;
    }
}
