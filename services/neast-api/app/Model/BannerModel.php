<?php

declare(strict_types=1);

namespace App\Model;

/**
 * 首页 Banner
 *
 * @property int $id 主键ID
 * @property string $image 图片路径
 * @property string $link 跳转链接
 * @property int $sort 排序
 * @property int $status 状态 0停用 1启用
 * @property string|null $starts_at 展示开始时间
 * @property string|null $ends_at 展示结束时间
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class BannerModel extends Model
{
    public const STATUS_DISABLED = 0;

    public const STATUS_ENABLED = 1;

    protected ?string $table = 't_banner';

    protected array $fillable = [
        'image',
        'link',
        'sort',
        'status',
        'starts_at',
        'ends_at',
    ];

    protected array $casts = [
        'sort' => 'integer',
        'status' => 'integer',
    ];
}
