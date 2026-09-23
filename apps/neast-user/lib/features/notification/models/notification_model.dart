import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required int id,
    required String title,
    required String content,
    @JsonKey(name: 'is_read') @Default(0) int isRead,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  bool get isUnread => isRead == 0;

  String get displayDate {
    if (createdAt.isEmpty) return '';
    try {
      final normalized = createdAt.replaceFirst(' ', 'T');
      final date = DateTime.parse(normalized);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return createdAt;
    }
  }
}

@freezed
abstract class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    @Default([]) List<NotificationModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(15) int limit,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

@freezed
abstract class NotificationUnreadStatus with _$NotificationUnreadStatus {
  const factory NotificationUnreadStatus({
    @JsonKey(name: 'has_unread') @Default(false) bool hasUnread,
  }) = _NotificationUnreadStatus;

  factory NotificationUnreadStatus.fromJson(Map<String, dynamic> json) =>
      _$NotificationUnreadStatusFromJson(json);
}
