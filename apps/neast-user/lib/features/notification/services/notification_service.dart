import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/notification/models/notification_model.dart';

class NotificationService {
  NotificationService(this._dioClient);

  final DioClient _dioClient;

  Future<List<NotificationModel>> fetchList({
    int page = 1,
    int limit = 15,
  }) async {
    final response = await _dioClient.get(
      '/app/message/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return NotificationListResponse.fromJson(data).items;
  }

  Future<void> markAllRead() async {
    await _dioClient.post('/app/message/read-all');
  }

  Future<bool> fetchHasUnread() async {
    final response = await _dioClient.get('/app/message/has-unread');
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return NotificationUnreadStatus.fromJson(data).hasUnread;
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(dioClientProvider));
});
