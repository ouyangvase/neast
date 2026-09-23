<?php

declare(strict_types=1);

namespace App\Constants;

use Hyperf\Constants\AbstractConstants;
use Hyperf\Constants\Annotation\Constants;
use Hyperf\Constants\Annotation\Message;

/**
 * xx状态 (t_xx.xx_status)
 */
#[Constants]
class ExampleStatus extends AbstractConstants
{
    #[Message('待支付')]
    public const PENDING_PAY = 1;

    #[Message('已支付')]
    public const PAID = 2;

    #[Message('已完成')]
    public const COMPLETED = 3;

    #[Message('已取消')]
    public const CANCELLED = 4;

    #[Message('已关闭')]
    public const CLOSED = 5;
}
