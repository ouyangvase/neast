<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 商家端消息
 *
 * @property int $id 主键ID
 * @property int $merchant_id 商家ID
 * @property string $title 标题
 * @property string $content 内容
 * @property int $is_read 是否已读 0未读 1已读
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class MerchantMessageModel extends Model
{
    protected ?string $table = 't_message_merchant';

    protected array $fillable = [
        'merchant_id',
        'title',
        'content',
        'is_read',
    ];

    protected array $casts = [
        'merchant_id' => 'integer',
        'is_read' => 'integer',
    ];

    public function merchant(): BelongsTo
    {
        return $this->belongsTo(MerchantModel::class, 'merchant_id', 'id');
    }
}
