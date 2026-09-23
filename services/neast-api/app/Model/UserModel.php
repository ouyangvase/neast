<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;
use Hyperf\Database\Model\SoftDeletes;

/**
 * 用户模型
 *
 * @property int $id 主键ID
 * @property string $account 手机号（登录账号）
 * @property string $email 邮箱（可选）
 * @property string $password 密码哈希
 * @property string $first_name 名
 * @property string $last_name 姓
 * @property string $avatar 头像
 * @property string $id_type 证件类型 id_card身份证 passport护照
 * @property string $id_number 证件号码
 * @property string|null $id_valid_until 证件有效期(仅护照)
 * @property string $address 当前住址
 * @property string $invitation_code 邀请码
 * @property int $pid 上级用户ID
 * @property int $status 状态 0停用 1启用
 * @property int $tent_score Tent Score信用分
 * @property string $balance 钱包余额
 * @property string|null $last_active_at 最后活跃时间
 * @property string|null $last_latitude 最后上报纬度
 * @property string|null $last_longitude 最后上报经度
 * @property string|null $last_location_at 最后位置上报时间
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 */
class UserModel extends Model
{
    use SoftDeletes;
    public const ID_TYPE_ID_CARD = 'id_card';

    public const ID_TYPE_PASSPORT = 'passport';

    /** 用户最多可邀请人数上限 */
    public const MAX_INVITE_LIMIT = 4;

    protected ?string $table = 't_user';

    protected array $fillable = [
        'account',
        'email',
        'password',
        'first_name',
        'last_name',
        'avatar',
        'id_type',
        'id_number',
        'id_valid_until',
        'address',
        'invitation_code',
        'pid',
        'status',
        'tent_score',
        'balance',
    ];

    protected array $hidden = [
        'password',
        'deleted_at',
    ];

    protected array $casts = [
        'pid' => 'integer',
        'status' => 'integer',
        'tent_score' => 'integer',
        'balance' => 'decimal:2',
        'id_valid_until' => 'date:Y-m-d',
        'last_active_at' => 'datetime:Y-m-d H:i:s',
        'last_latitude' => 'decimal:7',
        'last_longitude' => 'decimal:7',
        'last_location_at' => 'datetime:Y-m-d H:i:s',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function parent(): BelongsTo
    {
        return $this->belongsTo(self::class, 'pid', 'id');
    }
}
