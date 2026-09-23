// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MerchantModel _$MerchantModelFromJson(Map<String, dynamic> json) =>
    _MerchantModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      image: json['image'] as String? ?? '',
      distance: (json['distance'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      nearestMerchant: json['nearest_merchant'] == null
          ? null
          : MerchantModel.fromJson(
              json['nearest_merchant'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MerchantModelToJson(_MerchantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'image': instance.image,
      'distance': instance.distance,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'category_id': instance.categoryId,
      'nearest_merchant': instance.nearestMerchant,
    };

_MerchantListResponse _$MerchantListResponseFromJson(
  Map<String, dynamic> json,
) => _MerchantListResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$MerchantListResponseToJson(
  _MerchantListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
