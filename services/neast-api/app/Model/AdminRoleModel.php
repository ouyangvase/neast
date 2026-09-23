<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\HasMany;
use Hyperf\Database\Model\SoftDeletes;

/**
 * 管理员角色模型
 *
 * @property int $id 主键ID
 * @property string $name 角色名称
 * @property string $code 角色编码
 * @property string $description 描述
 * @property array|null $permissions 权限code数组
 * @property int $status 状态 0停用 1启用
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 */
class AdminRoleModel extends Model
{
    use SoftDeletes;

    protected ?string $table = 't_admin_role';

    protected array $fillable = [
        'name',
        'code',
        'description',
        'permissions',
        'status',
    ];

    protected array $hidden = [
        'deleted_at',
    ];

    protected array $casts = [
        'status' => 'integer',
        'permissions' => 'array',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];

    /**
     * 角色下的员工
     */
    public function admins(): HasMany
    {
        return $this->hasMany(AdminModel::class, 'role_id', 'id');
    }
}
