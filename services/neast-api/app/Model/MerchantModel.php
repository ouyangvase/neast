<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;
use Hyperf\Database\Model\SoftDeletes;

/**
 * 商家模型
 *
 * @property int $id 主键ID
 * @property string|null $latitude 纬度
 * @property string|null $longitude 经度
 * @property string $name 商家名称
 * @property int|null $category_id 商家分类ID
 * @property string $address 地址
 * @property string $image 图片URL
 * @property string $registration_number 注册号文件URL
 * @property string|null $registration_no 注册号
 * @property int $points_per_rm 赠送多少积分需支付1RM佣金
 * @property string $password 密码哈希
 * @property string $email 邮箱
 * @property string $phone 电话号码
 * @property string $contact_name 负责人名称
 * @property string $contact_phone 负责人电话
 * @property string $contact_email 负责人邮箱
 * @property string $balance 余额
 * @property int $status 状态 0停用 1启用
 * @property int $is_recommended 是否推荐 0否 1是
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 */
class MerchantModel extends Model
{
    use SoftDeletes;

    protected ?string $table = 't_merchant';

    protected array $fillable = [
        'latitude',
        'longitude',
        'name',
        'category_id',
        'address',
        'image',
        'registration_number',
        'registration_no',
        'points_per_rm',
        'password',
        'email',
        'phone',
        'contact_name',
        'contact_phone',
        'contact_email',
        'status',
        'is_recommended',
    ];

    protected array $hidden = [
        'password',
        'deleted_at',
    ];

    protected array $casts = [
        'latitude' => 'string',
        'longitude' => 'string',
        'category_id' => 'integer',
        'points_per_rm' => 'integer',
        'status' => 'integer',
        'is_recommended' => 'integer',
        'balance' => 'decimal:2',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(MerchantCategoryModel::class, 'category_id', 'id');
    }
}
