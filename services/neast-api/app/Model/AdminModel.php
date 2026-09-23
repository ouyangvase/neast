<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;
use Hyperf\Database\Model\SoftDeletes;

/**
 * 管理员(员工)模型
 *
 * @property int $id 主键ID
 * @property string $avatar 头像
 * @property string $username 登录账号
 * @property string $real_name 员工姓名
 * @property string $password 密码哈希
 * @property string $email 邮箱
 * @property string $phone 联系电话
 * @property int $role_id 角色ID
 * @property string $data_scope 数据权限范围
 * @property int $status 状态 0停用 1启用
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 * @property AdminRoleModel|null $role 所属角色
 */
class AdminModel extends Model
{
    use SoftDeletes;

    protected ?string $table = 't_admin';

    protected array $fillable = [
        'avatar',
        'username',
        'real_name',
        'password',
        'email',
        'phone',
        'role_id',
        'data_scope',
        'status',
    ];

    protected array $hidden = [
        'password',
        'deleted_at',
    ];

    protected array $casts = [
        'role_id' => 'integer',
        'status' => 'integer',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];

    /**
     * 所属角色
     */
    public function role(): BelongsTo
    {
        return $this->belongsTo(AdminRoleModel::class, 'role_id', 'id');
    }
}
