<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户充值记录
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
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
class UserTopupModel extends Model
{
    public const PAYMENT_METHOD_FPX = 'fpx';

    public const PAYMENT_METHOD_TNG = 'tng';

    public const PAYMENT_METHOD_GRAB = 'grab';

    public const PAYMENT_METHOD_VISA = 'visa';

    public const STATUS_PENDING = 0;

    public const STATUS_SUCCESS = 1;

    public const STATUS_FAILED = 2;

    protected ?string $table = 't_user_topup';

    protected array $fillable = [
        'user_id',
        'amount',
        'payment_method',
        'order_id',
        'status',
        'txn_id',
        'channel',
        'paid_at',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'amount' => 'decimal:2',
        'status' => 'integer',
        'paid_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }
}
