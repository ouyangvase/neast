<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\SoftDeletes;

/**
 * 优惠券分类
 *
 * @property int $id 主键ID
 * @property string $name 分类名称
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 */
class CouponCategoryModel extends Model
{
    use SoftDeletes;

    protected ?string $table = 't_coupon_category';

    protected array $fillable = [
        'name',
    ];

    protected array $hidden = [
        'deleted_at',
    ];
}
