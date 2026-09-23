// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MerchantCategoryModel _$MerchantCategoryModelFromJson(
  Map<String, dynamic> json,
) => _MerchantCategoryModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$MerchantCategoryModelToJson(
  _MerchantCategoryModel instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_MerchantCategoryListResponse _$MerchantCategoryListResponseFromJson(
  Map<String, dynamic> json,
) => _MerchantCategoryListResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => MerchantCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$MerchantCategoryListResponseToJson(
  _MerchantCategoryListResponse instance,
) => <String, dynamic>{'items': instance.items};
