// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointsLogModel _$PointsLogModelFromJson(Map<String, dynamic> json) =>
    _PointsLogModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      points: (json['points'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$PointsLogModelToJson(_PointsLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'points': instance.points,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'created_at': instance.createdAt,
    };

_PointsLogListResponse _$PointsLogListResponseFromJson(
  Map<String, dynamic> json,
) => _PointsLogListResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PointsLogModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 15,
);

Map<String, dynamic> _$PointsLogListResponseToJson(
  _PointsLogListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
