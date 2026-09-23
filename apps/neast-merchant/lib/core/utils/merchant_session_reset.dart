import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/auth/provider/login_provider.dart';
import 'package:neast/features/daily_closing/providers/daily_closing_transaction_list_provider.dart';
import 'package:neast/features/main/pages/main_screen.dart';
import 'package:neast/features/notification/providers/notification_list_provider.dart';
import 'package:neast/features/transaction/providers/transaction_list_provider.dart';
import 'package:neast/features/wallet/providers/wallet_topup_list_provider.dart';

/// 登出时同步清空商家会话状态，不触发接口请求。
void clearMerchantSessionState(Ref ref) {
  ref.read(merchantInfoProvider.notifier).clear();
  ref.read(loginProvider.notifier).reset();
}

/// 离开主界面后丢弃异步缓存，避免登出时 invalidate 触发无 token 请求。
///
/// 已监听 [authProvider] 的 Provider（settlement / give_points / daily_closing
/// summary 等）不在此 invalidate，登出时 auth=false 会自动置 null；
/// 此处再 invalidate 会在 logout 回调中形成循环依赖。
void invalidateMerchantSessionCache(Ref ref) {
  ref.invalidate(dailyClosingTransactionListProvider);
  ref.invalidate(transactionListProvider);
  ref.invalidate(walletTopupListProvider);
  ref.invalidate(notificationListProvider);
}

/// 导航到登录页后再清理缓存，确保无监听者触发请求。
void scheduleMerchantSessionCacheInvalidation(Ref ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ref.read(selectedIndexProvider.notifier).state = MainTab.scan;
    invalidateMerchantSessionCache(ref);
  });
}
