import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/pagination/paginated_list_notifier.dart';
import 'package:neast_landlords/core/pagination/paginated_list_state.dart';
import 'package:neast_landlords/features/notification/models/notification_model.dart';
import 'package:neast_landlords/features/notification/services/notification_service.dart';

class NotificationListNotifier
    extends PaginatedListNotifier<NotificationModel> {
  @override
  int get initialPageSize => 15;

  @override
  Future<List<NotificationModel>> fetchPage(int page, int pageSize) {
    return ref.read(notificationServiceProvider).fetchList(
          page: page,
          limit: pageSize,
        );
  }
}

final notificationListProvider = NotifierProvider<
    NotificationListNotifier,
    PaginatedListState<NotificationModel>>(
  NotificationListNotifier.new,
);
