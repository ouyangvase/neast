<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 优惠券关联商家
 *
 * @property int $id 主键ID
 * @property int $merchant_id 商家ID
 * @property int $coupon_id 优惠券ID
 * @property MerchantModel|null $merchant 商家
 */
class CouponMerchantModel extends Model
{
    public bool $timestamps = false;

    protected ?string $table = 't_coupon_merchant';

    protected array $fillable = [
        'merchant_id',
        'coupon_id',
    ];

    protected array $casts = [
        'merchant_id' => 'integer',
        'coupon_id' => 'integer',
    ];

    public function merchant(): BelongsTo
    {
        return $this->belongsTo(MerchantModel::class, 'merchant_id', 'id');
    }
}
