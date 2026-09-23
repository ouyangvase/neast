<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\SoftDeletes;

/**
 * 房东模型
 *
 * @property int $id 主键ID
 * @property string $name 名称
 * @property string $first_name 名
 * @property string $last_name 姓
 * @property string $phone 手机号（登录账号）
 * @property string $email 邮箱
 * @property string $bank_name 银行名称
 * @property string $bank_account 银行账号
 * @property string $account_holder_name 账户持有人姓名
 * @property string $bank_header_photo 银行抬头照路径
 * @property int $status 状态 0停用 1启用
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 */
class LandlordModel extends Model
{
    use SoftDeletes;

    protected ?string $table = 't_landlord';

    protected array $fillable = [
        'name',
        'first_name',
        'last_name',
        'phone',
        'email',
        'bank_name',
        'bank_account',
        'account_holder_name',
        'bank_header_photo',
        'status',
    ];

    protected array $hidden = [
        'deleted_at',
    ];

    protected array $casts = [
        'status' => 'integer',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];
}
