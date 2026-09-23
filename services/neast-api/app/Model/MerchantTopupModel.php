<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 商家充值记录
 *
 * @property int $id 主键ID
 * @property int $merchant_id 商家ID
 * @property string $amount 充值金额
 * @property string $payment_method 支付方式
 * @property string $order_id Fiuu 订单号
 * @property int $status 状态 0待支付 1成功 2失败
 * @property string $txn_id Fiuu 交易号
 * @property string $channel Fiuu 支付渠道
 * @property string|null $paid_at 支付时间
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class MerchantTopupModel extends Model
{
    public const PAYMENT_METHOD_FPX = 'fpx';

    public const PAYMENT_METHOD_TNG = 'tng';

    public const PAYMENT_METHOD_GRAB = 'grab';

    public const PAYMENT_METHOD_VISA = 'visa';

    public const STATUS_PENDING = 0;

    public const STATUS_SUCCESS = 1;

    public const STATUS_FAILED = 2;

    protected ?string $table = 't_merchant_topup';

    protected array $fillable = [
        'merchant_id',
        'amount',
        'payment_method',
        'order_id',
        'status',
        'txn_id',
        'channel',
        'paid_at',
    ];

    protected array $casts = [
        'merchant_id' => 'integer',
        'amount' => 'decimal:2',
        'status' => 'integer',
        'paid_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function merchant(): BelongsTo
    {
        return $this->belongsTo(MerchantModel::class, 'merchant_id', 'id');
    }
}
