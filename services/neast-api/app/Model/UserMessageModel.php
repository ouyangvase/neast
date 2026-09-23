<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 用户端消息
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property string $title 标题
 * @property string $content 内容
 * @property int $is_read 是否已读 0未读 1已读
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class UserMessageModel extends Model
{
    protected ?string $table = 't_message_user';

    protected array $fillable = [
        'user_id',
        'title',
        'content',
        'is_read',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'is_read' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }
}
