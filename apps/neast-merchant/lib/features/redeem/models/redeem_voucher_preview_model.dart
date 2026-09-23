import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'redeem_voucher_preview_model.freezed.dart';
part 'redeem_voucher_preview_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class RedeemVoucherPreviewModel with _$RedeemVoucherPreviewModel {
  const RedeemVoucherPreviewModel._();

  const factory RedeemVoucherPreviewModel({
    @JsonKey(name: 'user_coupon_id') @Default(0) int userCouponId,
    @Default('') String sn,
    @Default('') String name,
    @JsonKey(name: 'discount_amount') @Default('0') String discountAmount,
    @JsonKey(name: 'used_points') @Default(0) int usedPoints,
    @JsonKey(name: 'expire_at') @Default('') String expireAt,
    @JsonKey(name: 'merchant_names') @Default([]) List<String> merchantNames,
    @JsonKey(name: 'customer_name') @Default('') String customerName,
    @Default('') String contact,
  }) = _RedeemVoucherPreviewModel;

  factory RedeemVoucherPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$RedeemVoucherPreviewModelFromJson(json);

  String get merchantLabel =>
      merchantNames.where((name) => name.isNotEmpty).join(', ');

  String get pointsLabel =>
      NumberFormat('#,###').format(usedPoints);

  String get expireAtLabel {
    if (expireAt.isEmpty) return '-';
    final parsed = DateTime.tryParse(expireAt.replaceFirst(' ', 'T'));
    if (parsed == null) return expireAt;
    return DateFormat('dd MMM yyyy HH:mm', 'en_US').format(parsed.toLocal());
  }
}
