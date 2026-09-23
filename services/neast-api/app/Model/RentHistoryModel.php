<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 房租还款结算
 *
 * @property int $id 主键ID
 * @property int $rent_id 租金ID
 * @property int $user_id 用户ID
 * @property string $amount 还款金额
 * @property string $last_paid_date 最后交租时间
 * @property string|null $user_paid_at 用户付款时间
 * @property string $payment_method 付款方式
 * @property string|null $order_id Fiuu 订单号
 * @property string $txn_id Fiuu 交易号
 * @property string $channel Fiuu 支付渠道
 * @property string|null $platform_settled_at 平台结算时间
 * @property int|null $settled_by 结算操作人
 * @property string $receipt 结算收据URL
 * @property int $status 状态 0待还款 1已还款 2平台已结算 3已作废
 * @property int $is_confirm 房东是否确认 0否 1是
 * @property string|null $confirm_at 房东确认时间
 * @property int|null $inviter_user_id 邀请奖励已发放给的邀请人用户ID，NULL表示未发放
 * @property int $inviter_reward_points 已发放给邀请人的积分，0表示未发放
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class RentHistoryModel extends Model
{
    public const STATUS_PENDING = 0;

    public const STATUS_PAID = 1;

    public const STATUS_SETTLED = 2;

    public const STATUS_CANCELLED = 3;

    protected ?string $table = 't_rent_history';

    protected array $fillable = [
        'rent_id',
        'user_id',
        'amount',
        'last_paid_date',
        'user_paid_at',
        'payment_method',
        'order_id',
        'txn_id',
        'channel',
        'platform_settled_at',
        'settled_by',
        'receipt',
        'status',
        'is_confirm',
        'confirm_at',
        'inviter_user_id',
        'inviter_reward_points',
    ];

    protected array $casts = [
        'rent_id' => 'integer',
        'user_id' => 'integer',
        'amount' => 'decimal:2',
        'settled_by' => 'integer',
        'inviter_user_id' => 'integer',
        'inviter_reward_points' => 'integer',
        'status' => 'integer',
        'is_confirm' => 'integer',
        'last_paid_date' => 'date:Y-m-d',
        'user_paid_at' => 'datetime:Y-m-d H:i:s',
        'platform_settled_at' => 'datetime:Y-m-d H:i:s',
        'confirm_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function rent(): BelongsTo
    {
        return $this->belongsTo(RentModel::class, 'rent_id', 'id');
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }

    public function settledAdmin(): BelongsTo
    {
        return $this->belongsTo(AdminModel::class, 'settled_by', 'id');
    }

    public function inviter(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'inviter_user_id', 'id');
    }
}
