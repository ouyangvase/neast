import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/notification/services/notification_service.dart';

class NotificationUnreadNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return ref.read(notificationServiceProvider).fetchHasUnread();
  }

  Future<void> refresh() async {
    final previous = state.value ?? false;
    final result = await AsyncValue.guard(
      () => ref.read(notificationServiceProvider).fetchHasUnread(),
    );

    if (!ref.mounted) {
      return;
    }

    state = result.hasError
        ? AsyncData(previous)
        : result;
  }
}

final notificationUnreadProvider =
    AsyncNotifierProvider<NotificationUnreadNotifier, bool>(
  NotificationUnreadNotifier.new,
);
