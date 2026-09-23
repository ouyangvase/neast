import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 登录完成后待跳转的路由（如深链进入商家详情）。
final pendingRouteProvider =
    NotifierProvider<PendingRouteNotifier, String?>(PendingRouteNotifier.new);

class PendingRouteNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String route) {
    state = route;
  }

  void clear() {
    state = null;
  }
}
