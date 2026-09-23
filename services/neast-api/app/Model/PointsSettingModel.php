<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 积分设置
 *
 * @property int $id 固定为1
 * @property string $rent_points_multiplier 还租金积分金额倍数
 * @property string $spend_points_multiplier 消费可获得积分金额倍数
 * @property int $yuan_to_points 1 RM兑换积分数
 * @property int $inviter_reward_points 邀请人奖励积分
 * @property int $invitee_reward_points 被邀请人奖励积分
 */
class PointsSettingModel extends Model
{
    public bool $timestamps = false;

    public const SINGLETON_ID = 1;

    protected ?string $table = 't_points_setting';

    protected array $fillable = [
        'rent_points_multiplier',
        'spend_points_multiplier',
        'yuan_to_points',
        'inviter_reward_points',
        'invitee_reward_points',
    ];

    protected array $casts = [
        'rent_points_multiplier' => 'decimal:1',
        'spend_points_multiplier' => 'decimal:1',
        'yuan_to_points' => 'integer',
        'inviter_reward_points' => 'integer',
        'invitee_reward_points' => 'integer',
    ];
}
