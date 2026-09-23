<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 房东 FCM Token
 *
 * @property int $id 主键ID
 * @property int $landlord_id 房东ID
 * @property string $token FCM Token
 * @property string $platform 平台 ios/android
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class LandlordFcmTokenModel extends Model
{
    protected ?string $table = 't_landlord_fcm_token';

    protected array $fillable = [
        'landlord_id',
        'token',
        'platform',
    ];

    protected array $casts = [
        'landlord_id' => 'integer',
    ];

    public function landlord(): BelongsTo
    {
        return $this->belongsTo(LandlordModel::class, 'landlord_id', 'id');
    }
}
