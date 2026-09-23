import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_category_model.freezed.dart';
part 'coupon_category_model.g.dart';

@freezed
abstract class CouponCategoryModel with _$CouponCategoryModel {
  const factory CouponCategoryModel({
    required int id,
    @Default('') String name,
  }) = _CouponCategoryModel;

  factory CouponCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CouponCategoryModelFromJson(json);
}
