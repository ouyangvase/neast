<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户证件信息修改记录
 *
 * @property int $id 主键ID
 * @property int $user_id 被修改用户ID
 * @property array $before_data 变更前快照
 * @property array $after_data 变更后快照
 * @property int $admin_id 操作管理员ID
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class UserChangeLogModel extends Model
{
    protected ?string $table = 't_user_change_log';

    protected array $fillable = [
        'user_id',
        'before_data',
        'after_data',
        'admin_id',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'admin_id' => 'integer',
        'before_data' => 'array',
        'after_data' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }

    public function admin(): BelongsTo
    {
        return $this->belongsTo(AdminModel::class, 'admin_id', 'id');
    }
}
