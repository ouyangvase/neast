import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/deep_link/deep_link_navigation.dart';
import 'package:neast/core/deep_link/pending_route_provider.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/main/pages/main_screen.dart';

/// 登录或完善资料成功后，优先跳转到深链保存的目标页。
void navigateAfterAuth(BuildContext context, WidgetRef ref) {
  final pendingRoute = ref.read(pendingRouteProvider);
  if (pendingRoute != null && pendingRoute.isNotEmpty) {
    ref.read(pendingRouteProvider.notifier).clear();
    openDeepLinkRouteFromContext(context, ref, pendingRoute);
    return;
  }

  ref.read(selectedIndexProvider.notifier).state = MainTab.home;
  context.go(AppRoutes.main);
}

/// Splash 结束后，若存在待跳转深链则优先处理。
void navigateAfterSplash(BuildContext context, WidgetRef ref) {
  final pendingRoute = ref.read(pendingRouteProvider);
  if (pendingRoute != null && pendingRoute.isNotEmpty) {
    if (ref.read(isLoggedInProvider)) {
      ref.read(pendingRouteProvider.notifier).clear();
      openDeepLinkRouteFromContext(context, ref, pendingRoute);
    } else {
      context.go(AppRoutes.login);
    }
    return;
  }

  context.go('${AppRoutes.main}?fromSplash=true');
}
