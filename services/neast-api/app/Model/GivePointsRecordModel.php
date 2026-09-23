<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 积分发放记录
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property string $amount 消费金额
 * @property int $points 发放积分
 * @property int $merchant_id 商家ID
 * @property string $notes 备注
 * @property string $receipt_number 票据编号
 * @property string $receipt_path 票据文件
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property UserModel|null $user 关联用户
 * @property MerchantModel|null $merchant 关联商家
 */
class GivePointsRecordModel extends Model
{
    protected ?string $table = 't_give_points_record';

    protected array $fillable = [
        'user_id',
        'amount',
        'points',
        'merchant_id',
        'notes',
        'receipt_number',
        'receipt_path',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'amount' => 'decimal:2',
        'points' => 'integer',
        'merchant_id' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }

    public function merchant(): BelongsTo
    {
        return $this->belongsTo(MerchantModel::class, 'merchant_id', 'id');
    }
}
