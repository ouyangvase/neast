import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'coupon_list_item_model.freezed.dart';
part 'coupon_list_item_model.g.dart';

// ignore_for_file: invalid_annotation_target

enum CouponActionStatus {
  @JsonValue('redeem')
  redeem,
  @JsonValue('use_now')
  useNow,
  @JsonValue('fully_redeemed')
  fullyRedeemed,
}

enum MyVoucherStatus {
  @JsonValue('active')
  active,
  @JsonValue('used')
  used,
  @JsonValue('expired')
  expired,
}

@freezed
abstract class CouponListItemModel with _$CouponListItemModel {
  const CouponListItemModel._();

  const factory CouponListItemModel({
    required int id,
    @JsonKey(name: 'user_coupon_id') int? userCouponId,
    @Default('') String name,
    @JsonKey(name: 'required_points') @Default(0) int requiredPoints,
    @JsonKey(name: 'valid_days') @Default(0) int validDays,
    @JsonKey(name: 'category_id') @Default(0) int categoryId,
    @JsonKey(name: 'category_name') @Default('') String categoryName,
    @Default('') String image,
    @JsonKey(name: 'usage_condition') @Default('') String usageCondition,
    @JsonKey(name: 'discount_amount') @Default('0') String discountAmount,
    @JsonKey(name: 'merchant_names') @Default([]) List<String> merchantNames,
    @JsonKey(name: 'expire_at') String? expireAt,
    @JsonKey(name: 'redeemed_at') String? redeemedAt,
    @JsonKey(name: 'voucher_status') MyVoucherStatus? voucherStatus,
    @Default('') String sn,
    @Default('') String qrcode,
    @JsonKey(name: 'action_status')
    @Default(CouponActionStatus.redeem)
    CouponActionStatus actionStatus,
  }) = _CouponListItemModel;

  factory CouponListItemModel.fromJson(Map<String, dynamic> json) =>
      _$CouponListItemModelFromJson(json);

  String get pointsLabel => '${NumberFormat('#,###').format(requiredPoints)} pts';

  String get requiredPointsLabel =>
      '${NumberFormat('#,###').format(requiredPoints)} points';

  String get voucherAmountLabel {
    final amount = double.tryParse(discountAmount) ?? 0;
    return 'RM${NumberFormat('#,##0').format(amount)} Voucher';
  }

  String get expiringText => 'Expiring: $validDays days';

  String get discountAmountLabel {
    final amount = double.tryParse(discountAmount) ?? 0;
    return 'RM ${NumberFormat('#,##0.00').format(amount)}';
  }

  bool get showExpireAt =>
      actionStatus == CouponActionStatus.useNow &&
      expireAt != null &&
      expireAt!.isNotEmpty;

  String get expireAtLabel {
    if (expireAt == null || expireAt!.isEmpty) return '-';
    final parsed = DateTime.tryParse(expireAt!);
    if (parsed == null) return expireAt!;
    return DateFormat('dd MMM yyyy HH:mm', 'en_US').format(parsed.toLocal());
  }

  String get validDaysLabel => '$validDays days';

  String get myVoucherAmountTitle => voucherAmountLabel;

  bool get isMyVoucherActionEnabled => voucherStatus == MyVoucherStatus.active;

  String get myVoucherStatusLabel => switch (voucherStatus) {
        MyVoucherStatus.used => 'Used',
        MyVoucherStatus.expired => 'Expired',
        _ => 'Expires',
      };

  String get myVoucherDateLabel {
    if (voucherStatus == MyVoucherStatus.used) {
      return _formatMyVoucherDate(redeemedAt);
    }
    return _formatMyVoucherDate(expireAt);
  }

  String _formatMyVoucherDate(String? value) {
    if (value == null || value.isEmpty) return '-';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return DateFormat('dd MMM yyyy', 'en_US').format(parsed.toLocal());
  }

  String get myVoucherExpireDateLabel => _formatMyVoucherDate(expireAt);

  String get detailSubtitle {
    if (merchantNames.isNotEmpty) return merchantNames.join(', ');
    if (categoryName.isNotEmpty) return categoryName;
    return name;
  }

  String get detailDescription => name.isNotEmpty ? name : '-';

  String get detailTermsText => usageCondition;

  String get detailValidUntilLabel {
    if (showExpireAt) {
      return _formatMyVoucherDate(expireAt);
    }
    return 'Valid for $validDays days after redemption';
  }
}
