<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 官网图片
 *
 * @property int $id 主键ID
 * @property string $image 图片路径
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class WebsiteImageModel extends Model
{
    protected ?string $table = 't_website_image';

    protected array $fillable = [
        'image',
    ];
}
