<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户 FCM Token
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property string $token FCM Token
 * @property string $platform 平台 ios/android
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class UserFcmTokenModel extends Model
{
    protected ?string $table = 't_user_fcm_token';

    protected array $fillable = [
        'user_id',
        'token',
        'platform',
    ];

    protected array $casts = [
        'user_id' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }
}
