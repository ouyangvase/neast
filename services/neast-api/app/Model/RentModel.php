<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;
use Hyperf\Database\Model\SoftDeletes;

/**
 * 租金记录
 *
 * @property int $id 主键ID
 * @property int $user_id 用户ID
 * @property string $amount 还款金额
 * @property string $file 凭证文件URL
 * @property int $paid_at 交租日(每月几号)
 * @property string|null $first_pay_month 首次交租月份
 * @property int $lease_months 租期月份数
 * @property string|null $expire_date 房租到期时间
 * @property int|null $property_id 房产ID
 * @property string $property_name 房产名称(未绑定时用户填写)
 * @property int|null $landlord_id 房东ID
 * @property string $owner_name 房东名称(未绑物业时用户填写)
 * @property string $owner_email 未绑定房东时租客填写的邮箱
 * @property string $owner_phone 未绑定房东时租客填写的手机号
 * @property int $status 状态 0待审核 1审核通过 2驳回 3待绑定 4已终止
 * @property string $rejected_by 驳回来源 admin|owner
 * @property string|null $terminated_at 终止时间
 * @property int|null $terminated_by 终止操作人(admin id)
 * @property string $terminate_reason 终止原因
 * @property string $landlord_bank 房东银行
 * @property string $landlord_bank_account 房东银行账号
 * @property string $landlord_account_name 房东账号名称
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 * @property string|null $deleted_at 软删除时间
 */
class RentModel extends Model
{
    use SoftDeletes;

    public const STATUS_PENDING = 0;

    public const STATUS_APPROVED = 1;

    public const STATUS_REJECTED = 2;

    public const STATUS_PENDING_BIND = 3;

    public const STATUS_TERMINATED = 4;

    public const REJECTED_BY_ADMIN = 'admin';

    public const REJECTED_BY_OWNER = 'owner';

    protected ?string $table = 't_rent';

    protected array $fillable = [
        'user_id',
        'amount',
        'file',
        'paid_at',
        'first_pay_month',
        'lease_months',
        'expire_date',
        'property_id',
        'property_name',
        'landlord_id',
        'owner_name',
        'owner_email',
        'owner_phone',
        'status',
        'rejected_by',
        'terminated_at',
        'terminated_by',
        'terminate_reason',
        'landlord_bank',
        'landlord_bank_account',
        'landlord_account_name',
    ];

    protected array $hidden = [
        'deleted_at',
    ];

    protected array $casts = [
        'user_id' => 'integer',
        'amount' => 'decimal:2',
        'property_id' => 'integer',
        'landlord_id' => 'integer',
        'status' => 'integer',
        'terminated_by' => 'integer',
        'terminated_at' => 'datetime:Y-m-d H:i:s',
        'paid_at' => 'integer',
        'first_pay_month' => 'date:Y-m-d',
        'lease_months' => 'integer',
        'expire_date' => 'date:Y-m-d',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id');
    }

    public function property(): BelongsTo
    {
        return $this->belongsTo(LandlordPropertyModel::class, 'property_id', 'id');
    }

    public function landlord(): BelongsTo
    {
        return $this->belongsTo(LandlordModel::class, 'landlord_id', 'id');
    }

    /**
     * 审核通过且未过期（expire_date > 今天）
     *
     * @param \Hyperf\Database\Model\Builder $query
     * @return \Hyperf\Database\Model\Builder
     */
    public function scopeActiveApproved($query)
    {
        return $query->where('status', self::STATUS_APPROVED)
            ->where('expire_date', '>', date('Y-m-d'));
    }
}
