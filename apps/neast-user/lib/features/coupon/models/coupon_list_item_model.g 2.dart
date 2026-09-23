// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CouponListItemModel _$CouponListItemModelFromJson(Map<String, dynamic> json) =>
    _CouponListItemModel(
      id: (json['id'] as num).toInt(),
      userCouponId: (json['user_coupon_id'] as num?)?.toInt(),
      name: json['name'] as String? ?? '',
      requiredPoints: (json['required_points'] as num?)?.toInt() ?? 0,
      validDays: (json['valid_days'] as num?)?.toInt() ?? 0,
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      categoryName: json['category_name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      usageCondition: json['usage_condition'] as String? ?? '',
      discountAmount: json['discount_amount'] as String? ?? '0',
      merchantNames:
          (json['merchant_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      expireAt: json['expire_at'] as String?,
      redeemedAt: json['redeemed_at'] as String?,
      voucherStatus: $enumDecodeNullable(
        _$MyVoucherStatusEnumMap,
        json['voucher_status'],
      ),
      sn: json['sn'] as String? ?? '',
      qrcode: json['qrcode'] as String? ?? '',
      actionStatus:
          $enumDecodeNullable(
            _$CouponActionStatusEnumMap,
            json['action_status'],
          ) ??
          CouponActionStatus.redeem,
    );

Map<String, dynamic> _$CouponListItemModelToJson(
  _CouponListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_coupon_id': instance.userCouponId,
  'name': instance.name,
  'required_points': instance.requiredPoints,
  'valid_days': instance.validDays,
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'image': instance.image,
  'usage_condition': instance.usageCondition,
  'discount_amount': instance.discountAmount,
  'merchant_names': instance.merchantNames,
  'expire_at': instance.expireAt,
  'redeemed_at': instance.redeemedAt,
  'voucher_status': _$MyVoucherStatusEnumMap[instance.voucherStatus],
  'sn': instance.sn,
  'qrcode': instance.qrcode,
  'action_status': _$CouponActionStatusEnumMap[instance.actionStatus]!,
};

const _$MyVoucherStatusEnumMap = {
  MyVoucherStatus.active: 'active',
  MyVoucherStatus.used: 'used',
  MyVoucherStatus.expired: 'expired',
};

const _$CouponActionStatusEnumMap = {
  CouponActionStatus.redeem: 'redeem',
  CouponActionStatus.useNow: 'use_now',
  CouponActionStatus.fullyRedeemed: 'fully_redeemed',
};
