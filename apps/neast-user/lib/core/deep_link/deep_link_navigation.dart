import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/deep_link/deep_link_parser.dart';
import 'package:neast/core/deep_link/pending_route_provider.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/main/pages/main_screen.dart';

/// 打开深链目标页。商家详情先进入首页再 push，保证返回栈正常。
void openDeepLinkRoute(
  GoRouter router,
  String route, {
  void Function()? onOpenMerchantFromMain,
}) {
  if (DeepLinkParser.isMerchantDetailRoute(route)) {
    onOpenMerchantFromMain?.call();
    router.go(AppRoutes.main);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      router.push(route);
    });
    return;
  }

  router.go(route);
}

void openDeepLinkRouteFromContext(
  BuildContext context,
  WidgetRef ref,
  String route,
) {
  openDeepLinkRoute(
    GoRouter.of(context),
    route,
    onOpenMerchantFromMain: () {
      ref.read(selectedIndexProvider.notifier).state = MainTab.home;
    },
  );
}

void openDeepLinkRouteWithRef(
  GoRouter router,
  Ref ref,
  String route,
) {
  openDeepLinkRoute(
    router,
    route,
    onOpenMerchantFromMain: () {
      ref.read(selectedIndexProvider.notifier).state = MainTab.home;
    },
  );
}

/// 首页加载后，处理 redirect 暂存的待跳转深链。
void flushPendingDeepLinkOnMain(BuildContext context, WidgetRef ref) {
  final pendingRoute = ref.read(pendingRouteProvider);
  if (pendingRoute == null || pendingRoute.isEmpty) {
    return;
  }

  ref.read(pendingRouteProvider.notifier).clear();
  openDeepLinkRouteFromContext(context, ref, pendingRoute);
}
