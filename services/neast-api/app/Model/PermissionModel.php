<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 权限模型
 *
 * @property int $id 主键ID
 * @property string $code 权限标志(唯一)
 * @property string $name 权限名称
 * @property int $parent_id 上级权限ID
 * @property string $type 类型 menu菜单 button按钮
 * @property string $path 菜单路由路径
 * @property int $sort 排序
 * @property int $status 状态 0停用 1启用
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class PermissionModel extends Model
{
    protected ?string $table = 't_permission';

    protected array $fillable = [
        'code',
        'name',
        'parent_id',
        'type',
        'path',
        'sort',
        'status',
    ];

    protected array $casts = [
        'parent_id' => 'integer',
        'sort' => 'integer',
        'status' => 'integer',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];
}
