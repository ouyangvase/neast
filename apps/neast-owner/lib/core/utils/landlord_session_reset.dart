import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';
import 'package:neast_landlords/features/auth/provider/login_provider.dart';
import 'package:neast_landlords/features/main/pages/main_screen.dart';
import 'package:neast_landlords/features/notification/providers/notification_list_provider.dart';
import 'package:neast_landlords/features/properties/providers/property_list_provider.dart';
import 'package:neast_landlords/features/records/providers/record_list_provider.dart';

/// 登出时同步清空房东会话状态，不触发接口请求。
void clearLandlordSessionState(Ref ref) {
  ref.read(landlordInfoProvider.notifier).clear();
  ref.read(loginProvider.notifier).reset();
  ref.read(propertyListTotalProvider.notifier).state = 0;
  ref.read(recordAmountSumProvider.notifier).state = '0';
}

/// 离开主界面后丢弃分页列表缓存。
///
/// 已监听 [authProvider] 的 AsyncNotifier（home dashboard / ack / bind 等）
/// 不在此 invalidate，登出时 auth=false 会自动置空，避免无 token 请求与循环依赖。
void invalidateLandlordSessionCache(Ref ref) {
  ref.invalidate(propertyListProvider);
  ref.invalidate(notificationListProvider);
  ref.invalidate(recordListProvider);
}

/// 导航到登录页后再清理缓存，确保无监听者触发请求。
void scheduleLandlordSessionCacheInvalidation(Ref ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ref.read(selectedIndexProvider.notifier).state = MainTab.home;
    invalidateLandlordSessionCache(ref);
  });
}
