<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 商家 FCM Token
 *
 * @property int $id 主键ID
 * @property int $merchant_id 商家ID
 * @property string $token FCM Token
 * @property string $platform 平台 ios/android
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class MerchantFcmTokenModel extends Model
{
    protected ?string $table = 't_merchant_fcm_token';

    protected array $fillable = [
        'merchant_id',
        'token',
        'platform',
    ];

    protected array $casts = [
        'merchant_id' => 'integer',
    ];

    public function merchant(): BelongsTo
    {
        return $this->belongsTo(MerchantModel::class, 'merchant_id', 'id');
    }
}
