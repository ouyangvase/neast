<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户积分收支流水
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property int $points 积分变动，收入为正、支出为负
 * @property string $title 标题
 * @property string $subtitle 副标题
 * @property string|null $created_at 收支时间
 * @property string|null $updated_at 更新时间
 * @property UserModel|null $user 关联用户
 */
class PointsLogModel extends Model
{
    protected ?string $table = 't_points_log';

    protected array $fillable = [
        'user_id',
        'points',
        'title',
        'subtitle',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'points' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }
}
