<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;
use Hyperf\Database\Model\SoftDeletes;

/**
 * 房东物业, 房产
 *
 * @property int $id 主键ID
 * @property int $landlord_id 房东ID
 * @property string $sn 唯一编号
 * @property string $name 名称
 * @property string $address 地址
 * @property string $image 图片URL
 * @property string $file 文件URL
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 */
class LandlordPropertyModel extends Model
{
    use SoftDeletes;

    protected ?string $table = 't_landlord_property';

    protected array $fillable = [
        'landlord_id',
        'sn',
        'name',
        'address',
        'image',
        'file',
    ];

    protected array $hidden = [
        'deleted_at',
    ];

    protected array $casts = [
        'landlord_id' => 'integer',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function landlord(): BelongsTo
    {
        return $this->belongsTo(LandlordModel::class, 'landlord_id', 'id');
    }
}
