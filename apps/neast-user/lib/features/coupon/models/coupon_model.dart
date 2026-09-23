import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class CouponModel with _$CouponModel {
  const CouponModel._();

  const factory CouponModel({
    required int id,
    @Default('') String name,
    @JsonKey(name: 'required_points') @Default(0) int requiredPoints,
    @Default('') String image,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  String get requiredPointsLabel =>
      '${NumberFormat('#,###').format(requiredPoints)} points';
}
