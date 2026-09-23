<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\UserAgreementModel;

class UserAgreementService extends AbstractAgreementService
{
    protected function getModelClass(): string
    {
        return UserAgreementModel::class;
    }
}
