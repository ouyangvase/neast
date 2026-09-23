<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 用户端协议
 *
 * @property int $id 主键ID
 * @property string $title 标题
 * @property string $content 协议内容
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class UserAgreementModel extends Model
{
    protected ?string $table = 't_user_agreement';

    protected array $fillable = [
        'title',
        'content',
    ];
}
