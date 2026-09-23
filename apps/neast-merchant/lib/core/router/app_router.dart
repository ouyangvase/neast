import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/common/not_found_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/router/routes/account_routes.dart';
import 'package:neast/core/router/routes/auth_routes.dart';
import 'package:neast/core/router/routes/daily_closing_routes.dart';
import 'package:neast/core/router/routes/give_points_routes.dart';
import 'package:neast/core/router/routes/notification_routes.dart';
import 'package:neast/core/router/routes/redeem_routes.dart';
import 'package:neast/core/router/routes/rich_text_routes.dart';
import 'package:neast/core/router/routes/scan_routes.dart';
import 'package:neast/core/router/routes/settlement_routes.dart';
import 'package:neast/core/router/routes/shell_routes.dart';
import 'package:neast/core/router/routes/transaction_routes.dart';
import 'package:neast/core/router/routes/wallet_routes.dart';

/// 路由配置提供者
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = ref.read(isLoggedInProvider);
      if (isLoggedIn) {
        return null;
      }

      final isAtLoginPage = state.matchedLocation == AppRoutes.login;
      final isAtSplashPage = state.matchedLocation == AppRoutes.splash;

      if (!isAtLoginPage && !isAtSplashPage) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: [
      ...authRoutes,
      ...shellRoutes,
      ...richTextRoutes,
      ...notificationRoutes,
      ...dailyClosingRoutes,
      ...givePointsRoutes,
      ...settlementRoutes,
      ...accountRoutes,
      ...walletRoutes,
      ...transactionRoutes,
      ...scanRoutes,
      ...redeemRoutes,
    ],
    errorBuilder: (context, state) => NotFoundScreen(uri: state.uri),
  );
});
