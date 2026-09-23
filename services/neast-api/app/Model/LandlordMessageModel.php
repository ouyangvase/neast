<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 房东端消息
 *
 * @property int $id 主键ID
 * @property int $landlord_id 房东ID
 * @property string $title 标题
 * @property string $content 内容
 * @property int $is_read 是否已读 0未读 1已读
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class LandlordMessageModel extends Model
{
    protected ?string $table = 't_message_landlord';

    protected array $fillable = [
        'landlord_id',
        'title',
        'content',
        'is_read',
    ];

    protected array $casts = [
        'landlord_id' => 'integer',
        'is_read' => 'integer',
    ];

    public function landlord(): BelongsTo
    {
        return $this->belongsTo(LandlordModel::class, 'landlord_id', 'id');
    }
}
