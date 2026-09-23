import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/deep_link/deep_link_navigation.dart';
import 'package:neast/core/deep_link/deep_link_parser.dart';
import 'package:neast/core/deep_link/pending_route_provider.dart';
import 'package:neast/core/router/app_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/auth/services/auth_service.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService(ref);
  ref.onDispose(service.dispose);
  return service;
});

class DeepLinkService {
  DeepLinkService(this._ref);

  final Ref _ref;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  bool _started = false;

  Future<void> start() async {
    if (_started) {
      return;
    }
    _started = true;

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri, fromColdStart: true);
    }

    _subscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri, fromColdStart: false),
    );
  }

  void _handleUri(Uri uri, {required bool fromColdStart}) {
    final route = DeepLinkParser.parseRoute(uri);
    if (route == null) {
      return;
    }

    if (fromColdStart) {
      _ref.read(pendingRouteProvider.notifier).set(route);
      return;
    }

    final isLoggedIn = _ref.read(isLoggedInProvider);
    if (isLoggedIn) {
      openDeepLinkRouteWithRef(_ref.read(appRouterProvider), _ref, route);
      return;
    }

    _ref.read(pendingRouteProvider.notifier).set(route);
    _ref.read(appRouterProvider).go(AppRoutes.login);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
