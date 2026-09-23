<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 商家端协议
 *
 * @property int $id 主键ID
 * @property string $title 标题
 * @property string $content 协议内容
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class MerchantAgreementModel extends Model
{
    protected ?string $table = 't_merchant_agreement';

    protected array $fillable = [
        'title',
        'content',
    ];
}
