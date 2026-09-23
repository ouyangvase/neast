// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      isRead: (json['is_read'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
    };

_NotificationListResponse _$NotificationListResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationListResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 15,
);

Map<String, dynamic> _$NotificationListResponseToJson(
  _NotificationListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

_NotificationUnreadStatus _$NotificationUnreadStatusFromJson(
  Map<String, dynamic> json,
) => _NotificationUnreadStatus(hasUnread: json['has_unread'] as bool? ?? false);

Map<String, dynamic> _$NotificationUnreadStatusToJson(
  _NotificationUnreadStatus instance,
) => <String, dynamic>{'has_unread': instance.hasUnread};
