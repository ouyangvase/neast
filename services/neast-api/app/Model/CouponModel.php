<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;
use Hyperf\Database\Model\Relations\HasMany;

/**
 * 优惠券
 *
 * @property int $id 主键ID
 * @property string $name 名称
 * @property int $required_points 所需积分
 * @property int $valid_days 有效期(天)
 * @property string $discount_amount 优惠金额
 * @property string|null $usage_condition 使用条件
 * @property int $status 状态 0停用 1启用
 * @property string $origin 来源 admin管理员 merchant商家
 * @property string $review_status 审核 pending待审 approved通过 rejected拒绝
 * @property int|null $redeem_limit 兑换次数 NULL表示不限制
 * @property int $category_id 优惠券分类ID
 * @property string $image 列表展示图片
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property CouponCategoryModel|null $category 所属分类
 * @property \Hyperf\Database\Model\Collection|CouponMerchantModel[] $merchants 关联商家
 */
class CouponModel extends Model
{
    protected ?string $table = 't_coupon';

    protected array $fillable = [
        'name',
        'required_points',
        'valid_days',
        'discount_amount',
        'usage_condition',
        'status',
        'origin',
        'review_status',
        'redeem_limit',
        'category_id',
        'image',
    ];

    protected array $casts = [
        'required_points' => 'integer',
        'valid_days' => 'integer',
        'discount_amount' => 'decimal:2',
        'status' => 'integer',
        'redeem_limit' => 'integer',
        'category_id' => 'integer',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(CouponCategoryModel::class, 'category_id', 'id');
    }

    public function merchants(): HasMany
    {
        return $this->hasMany(CouponMerchantModel::class, 'coupon_id', 'id');
    }
}
