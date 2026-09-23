// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      userId: json['userId'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresTime: (json['expiresTime'] as num).toInt(),
      profileCompleted: json['profileCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresTime': instance.expiresTime,
      'profileCompleted': instance.profileCompleted,
    };
