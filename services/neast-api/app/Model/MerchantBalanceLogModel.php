<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 商家余额流水
 *
 * @property int $id 主键ID
 * @property int $merchant_id 商家ID
 * @property string $amount 变动金额(可为负数)
 * @property string $balance_after 交易后余额
 * @property string $remark 备注
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class MerchantBalanceLogModel extends Model
{
    protected ?string $table = 't_merchant_balance_log';

    protected array $fillable = [
        'merchant_id',
        'amount',
        'balance_after',
        'remark',
    ];

    protected array $casts = [
        'merchant_id' => 'integer',
        'amount' => 'decimal:2',
        'balance_after' => 'decimal:2',
    ];
}
