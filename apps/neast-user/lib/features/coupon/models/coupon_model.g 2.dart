// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CouponModel _$CouponModelFromJson(Map<String, dynamic> json) => _CouponModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  requiredPoints: (json['required_points'] as num?)?.toInt() ?? 0,
  image: json['image'] as String? ?? '',
);

Map<String, dynamic> _$CouponModelToJson(_CouponModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'required_points': instance.requiredPoints,
      'image': instance.image,
    };
