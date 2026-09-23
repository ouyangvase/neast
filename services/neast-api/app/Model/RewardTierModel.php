<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 奖励等级
 *
 * @property int $id 主键ID
 * @property string $name 等级名称
 * @property int $min_points 最低积分
 * @property int $max_points 最高积分
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class RewardTierModel extends Model
{
    protected ?string $table = 't_reward_tier';

    protected array $fillable = [
        'name',
        'min_points',
        'max_points',
    ];

    protected array $casts = [
        'min_points' => 'integer',
        'max_points' => 'integer',
    ];
}
