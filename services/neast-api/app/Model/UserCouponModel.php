<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户兑换优惠券记录
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property int $coupon_id 优惠券ID
 * @property string $sn 券码，6位大写字母数字
 * @property string $redeem_token 核销 token，QR 编码用
 * @property int $used_points 兑换使用积分
 * @property string $expire_at 过期时间
 * @property string $discount_amount 优惠金额(兑换快照)
 * @property string $name 优惠券名称(兑换快照)
 * @property string|null $usage_condition 使用条件(兑换快照)
 * @property string $merchant_ids 可用商家ID快照，逗号分隔
 * @property int $status 状态 0未使用 1已使用
 * @property int $redeemed_merchant_id 核销商家ID
 * @property string|null $redeemed_at 商家核销时间
 * @property string|null $created_at 兑换时间
 * @property string|null $updated_at 更新时间
 * @property UserModel|null $user 关联用户
 * @property CouponModel|null $coupon 关联优惠券
 */
class UserCouponModel extends Model
{
    public const STATUS_UNUSED = 0;

    public const STATUS_USED = 1;

    protected ?string $table = 't_user_coupon';

    protected array $fillable = [
        'user_id',
        'coupon_id',
        'sn',
        'redeem_token',
        'used_points',
        'expire_at',
        'discount_amount',
        'name',
        'usage_condition',
        'merchant_ids',
        'status',
        'redeemed_merchant_id',
        'redeemed_at',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'coupon_id' => 'integer',
        'used_points' => 'integer',
        'discount_amount' => 'decimal:2',
        'status' => 'integer',
        'redeemed_merchant_id' => 'integer',
        'expire_at' => 'datetime:Y-m-d H:i:s',
        'redeemed_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }

    public function coupon(): BelongsTo
    {
        return $this->belongsTo(CouponModel::class, 'coupon_id', 'id');
    }
}
