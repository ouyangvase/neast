// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      userId: json['userId'] as String? ?? '',
      account: json['account'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      idType: json['idType'] as String? ?? 'id_card',
      idNumber: json['idNumber'] as String? ?? '',
      idValidUntil: json['idValidUntil'] as String?,
      address: json['address'] as String? ?? '',
      profileCompleted: json['profileCompleted'] as bool? ?? false,
      points: (json['points'] as num?)?.toInt() ?? 0,
      pointsApproxRm: (json['pointsApproxRm'] as num?)?.toDouble() ?? 0,
      qrCode: json['qrCode'] as String? ?? '',
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'account': instance.account,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'idType': instance.idType,
      'idNumber': instance.idNumber,
      'idValidUntil': instance.idValidUntil,
      'address': instance.address,
      'profileCompleted': instance.profileCompleted,
      'points': instance.points,
      'pointsApproxRm': instance.pointsApproxRm,
      'qrCode': instance.qrCode,
    };
