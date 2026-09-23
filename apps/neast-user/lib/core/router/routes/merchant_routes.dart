import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/merchant/models/merchant_list_kind.dart';
import 'package:neast/features/merchant/pages/merchant_list_screen.dart';
// import 'package:neast/features/merchant/pages/merchant_map_demo_screen.dart';
import 'package:neast/features/merchant/pages/merchant_map_screen.dart';
import 'package:neast/features/merchant/pages/merchant_screen.dart';

final List<GoRoute> merchantRoutes = [
  GoRoute(
    path: AppRoutes.merchantMap,
    name: 'merchantMap',
    // builder: (context, state) => const MerchantMapDemoScreen(),
    builder: (context, state) => const MerchantMapScreen(),
  ),
  GoRoute(
    path: AppRoutes.merchantList,
    name: 'merchantList',
    builder: (context, state) {
      final kind = MerchantListKind.fromQuery(state.uri.queryParameters['kind']) ??
          MerchantListKind.all;
      final headerOverride =
          MerchantListHeaderTitle.fromQuery(state.uri.queryParameters['header']);
      final headerTitle = MerchantListHeaderTitle.resolve(
        kind: kind,
        override: headerOverride,
      );

      return MerchantListScreen(
        kind: kind,
        headerTitle: headerTitle,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.merchant,
    name: 'merchant',
    builder: (context, state) {
      final id = int.parse(state.pathParameters['id']!);
      return MerchantScreen(merchantId: id);
    },
  ),
];
