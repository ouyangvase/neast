// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RentPropertyModel _$RentPropertyModelFromJson(Map<String, dynamic> json) =>
    _RentPropertyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      landlordName: json['landlord_name'] as String? ?? '',
    );

Map<String, dynamic> _$RentPropertyModelToJson(_RentPropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'landlord_name': instance.landlordName,
    };
