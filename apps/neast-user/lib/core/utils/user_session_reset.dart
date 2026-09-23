import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/auth/provider/login_provider.dart';
import 'package:neast/features/auth/provider/personal_profile_provider.dart';
import 'package:neast/features/coupon/providers/coupon_list_provider.dart';
import 'package:neast/features/coupon/providers/latest_coupon_provider.dart';
import 'package:neast/features/coupon/providers/my_voucher_list_provider.dart';
import 'package:neast/features/home/providers/home_dashboard_provider.dart';
import 'package:neast/features/home/providers/home_merchants_provider.dart';
import 'package:neast/features/home/providers/nearby_merchants_provider.dart';
import 'package:neast/features/merchant/providers/merchant_coupon_list_provider.dart';
import 'package:neast/features/merchant/providers/merchant_detail_provider.dart';
import 'package:neast/features/merchant/providers/merchant_list_provider.dart';
import 'package:neast/features/notification/providers/notification_list_provider.dart';
import 'package:neast/features/notification/providers/notification_unread_provider.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_list_provider.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_provider.dart';
import 'package:neast/features/pay_rent/providers/rent_history_provider.dart';
import 'package:neast/features/tent_score/providers/tent_score_provider.dart';
import 'package:neast/features/wallet/providers/wallet_balance_provider.dart';
import 'package:neast/features/wallet/providers/wallet_topup_list_provider.dart';

/// 登出时同步清空用户会话状态，不触发接口请求。
void clearUserSessionState(Ref ref) {
  ref.read(userProfileProvider.notifier).clear();
  ref.read(personalProfileProvider.notifier).reset();
  ref.read(loginProvider.notifier).reset();
}

/// 离开主界面后丢弃异步缓存，避免登出时 invalidate 触发无 token 请求。
void invalidateUserSessionCache(Ref ref) {
  ref.invalidate(payRentListProvider);
  ref.invalidate(payRentRecentHistoryProvider);
  ref.invalidate(latestCouponProvider);
  ref.invalidate(myVoucherCountProvider);
  ref.invalidate(walletBalanceProvider);
  ref.invalidate(tentScoreProvider);
  ref.invalidate(homeDashboardProvider);
  ref.invalidate(homeAllMerchantsProvider);
  ref.invalidate(homeRecommendedMerchantsProvider);
  ref.invalidate(homeNearbyListMerchantsProvider);
  ref.invalidate(nearbyMerchantsProvider);
  ref.invalidate(notificationListProvider);
  ref.invalidate(notificationUnreadProvider);
  ref.invalidate(walletTopupListProvider);
  ref.invalidate(payRentProvider);
  ref.invalidate(myVoucherListProvider);
  ref.invalidate(couponListProvider);
  ref.invalidate(couponCategoriesProvider);
  ref.invalidate(rentHistoryListProvider);
  ref.invalidate(rentHistoryYearProvider);
  ref.invalidate(merchantListProvider);
  ref.invalidate(merchantCouponListProvider);
  ref.invalidate(merchantDetailProvider);
}

/// 导航到登录页后再清理缓存，确保无监听者触发请求。
void scheduleUserSessionCacheInvalidation(Ref ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    invalidateUserSessionCache(ref);
  });
}
