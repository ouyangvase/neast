import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/common/not_found_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/deep_link/deep_link_parser.dart';
import 'package:neast/core/deep_link/pending_route_provider.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/router/routes/account_routes.dart';
import 'package:neast/core/router/routes/auth_routes.dart';
import 'package:neast/core/router/routes/merchant_routes.dart';
import 'package:neast/core/router/routes/notification_routes.dart';
import 'package:neast/core/router/routes/points_routes.dart';
import 'package:neast/core/router/routes/coupon_routes.dart';
import 'package:neast/core/router/routes/refer_routes.dart';
import 'package:neast/core/router/routes/rich_text_routes.dart';
import 'package:neast/core/router/routes/shell_routes.dart';
import 'package:neast/core/router/routes/wallet_routes.dart';
import 'package:neast/core/router/routes/pay_rent_routes.dart';
import 'package:neast/core/router/routes/reward_routes.dart';
import 'package:neast/core/router/routes/scan_routes.dart';

/// 路由配置提供者
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final repairedRoute =
          DeepLinkParser.repairBrokenMerchantRoute(state.matchedLocation);
      if (repairedRoute != null) {
        ref.read(pendingRouteProvider.notifier).set(repairedRoute);
        if (ref.read(isLoggedInProvider)) {
          return AppRoutes.main;
        }
        return AppRoutes.login;
      }

      final isLoggedIn = ref.read(isLoggedInProvider);
      if (isLoggedIn) {
        return null;
      }

      final location = state.matchedLocation;
      if (DeepLinkParser.isMerchantDetailRoute(location)) {
        ref.read(pendingRouteProvider.notifier).set(location);
      }

      final isAtLoginPage = location == AppRoutes.login;
      final isAtSplashPage = location == AppRoutes.splash;
      final isAtVerifyPage = location == AppRoutes.verify;
      final isAtFullDataPage = location == AppRoutes.fullData;
      final isAtMainPage = location == AppRoutes.main;
      final isAtRichTextPage = location == AppRoutes.richText;
      final isAtMerchantMapPage = location == AppRoutes.merchantMap;
      final isAtMerchantListPage = location == AppRoutes.merchantList;
      final isAtCouponPage = location == AppRoutes.coupon;

      if (!isAtLoginPage &&
          !isAtSplashPage &&
          !isAtVerifyPage &&
          !isAtFullDataPage &&
          !isAtMainPage &&
          !isAtRichTextPage &&
          !isAtMerchantMapPage &&
          !isAtMerchantListPage &&
          !isAtCouponPage) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: [
      ...authRoutes,
      ...shellRoutes,
      ...richTextRoutes,
      ...notificationRoutes,
      ...accountRoutes,
      ...pointsRoutes,
      ...couponRoutes,
      ...merchantRoutes,
      ...referRoutes,
      ...walletRoutes,
      ...payRentRoutes,
      ...rewardRoutes,
      ...scanRoutes,
    ],
    errorBuilder: (context, state) => NotFoundScreen(uri: state.uri),
  );
});
