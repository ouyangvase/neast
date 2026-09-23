<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户日活跃
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property string $active_date 活跃日期 Y-m-d
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class UserActiveModel extends Model
{
    protected ?string $table = 't_user_active';

    protected array $fillable = [
        'user_id',
        'active_date',
    ];

    protected array $casts = [
        'user_id' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }
}
