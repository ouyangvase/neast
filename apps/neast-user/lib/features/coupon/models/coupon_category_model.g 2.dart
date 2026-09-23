// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CouponCategoryModel _$CouponCategoryModelFromJson(Map<String, dynamic> json) =>
    _CouponCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$CouponCategoryModelToJson(
  _CouponCategoryModel instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
