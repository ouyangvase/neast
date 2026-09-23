// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => _MemberModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phone: json['phone'] as String,
  avatar: json['avatar'] as String,
  birthday: json['birthday'] as String?,
  points: (json['points'] as num).toInt(),
  avatarType: (json['avatarType'] as num).toInt(),
  isEmployee: (json['isEmployee'] as num?)?.toInt(),
);

Map<String, dynamic> _$MemberModelToJson(_MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'birthday': instance.birthday,
      'points': instance.points,
      'avatarType': instance.avatarType,
      'isEmployee': instance.isEmployee,
    };
