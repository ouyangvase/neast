import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/features/common/not_found_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/router/routes/account_routes.dart';
import 'package:neast_landlords/core/router/routes/ack_routes.dart';
import 'package:neast_landlords/core/router/routes/auth_routes.dart';
import 'package:neast_landlords/core/router/routes/bind_request_routes.dart';
import 'package:neast_landlords/core/router/routes/notification_routes.dart';
import 'package:neast_landlords/core/router/routes/portfolio_routes.dart';
import 'package:neast_landlords/core/router/routes/properties_routes.dart';
import 'package:neast_landlords/core/router/routes/rent_routes.dart';
import 'package:neast_landlords/core/router/routes/rich_text_routes.dart';
import 'package:neast_landlords/core/router/routes/shell_routes.dart';

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
      final isAtVerifyPage = state.matchedLocation == AppRoutes.verify;
      final isAtSplashPage = state.matchedLocation == AppRoutes.splash;

      if (!isAtLoginPage && !isAtVerifyPage && !isAtSplashPage) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: [
      ...authRoutes,
      ...shellRoutes,
      ...richTextRoutes,
      ...notificationRoutes,
      ...rentRoutes,
      ...ackRoutes,
      ...bindRequestRoutes,
      ...propertiesRoutes,
      ...portfolioRoutes,
      ...accountRoutes,
    ],
    errorBuilder: (context, state) => NotFoundScreen(uri: state.uri),
  );
});
