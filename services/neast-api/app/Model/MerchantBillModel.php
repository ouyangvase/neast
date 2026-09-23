<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Relations\BelongsTo;

/**
 * 商家账单
 *
 * @property int $id 主键ID
 * @property int $merchant_id 商家ID
 * @property string $bill_month 账单年月 YYYY-MM
 * @property string $amount 账单金额
 * @property int $points 积分
 * @property int $is_paid 是否支付 0否 1是
 * @property string|null $payment_date 支付日期
 * @property string $payment_method 支付方式 wallet钱包 online网上支付
 * @property string $order_id Fiuu 订单号
 * @property string $txn_id Fiuu 交易号
 * @property string $channel Fiuu 支付渠道
 * @property string|null $pay_amount 含手续费实付金额
 * @property string|null $created_at 创建时间
 * @property string|null $updated_at 更新时间
 */
class MerchantBillModel extends Model
{
    public const PAYMENT_METHOD_WALLET = 'wallet';

    public const PAYMENT_METHOD_ONLINE = 'online';

    protected ?string $table = 't_merchant_bill';

    protected array $fillable = [
        'merchant_id',
        'bill_month',
        'amount',
        'points',
        'is_paid',
        'payment_date',
        'payment_method',
        'order_id',
        'txn_id',
        'channel',
        'pay_amount',
    ];

    protected array $casts = [
        'merchant_id' => 'integer',
        'amount' => 'decimal:2',
        'points' => 'integer',
        'is_paid' => 'integer',
        'payment_date' => 'date:Y-m-d',
        'pay_amount' => 'decimal:2',
    ];

    public function merchant(): BelongsTo
    {
        return $this->belongsTo(MerchantModel::class, 'merchant_id', 'id');
    }
}
