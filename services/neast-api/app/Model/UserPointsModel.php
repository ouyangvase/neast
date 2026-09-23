<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户积分明细
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property int $points 积分数量
 * @property string $expired_date 过期日期
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property UserModel|null $user 关联用户
 */
class UserPointsModel extends Model
{
    protected ?string $table = 't_user_points';

    protected array $fillable = [
        'user_id',
        'points',
        'expired_date',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'points' => 'integer',
        'expired_date' => 'date:Y-m-d',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }
}
