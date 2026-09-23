import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/redeem/models/redeem_voucher_route_args.dart';
import 'package:neast/features/redeem/pages/redeem_voucher_screen.dart';

final List<GoRoute> redeemRoutes = [
  GoRoute(
    path: AppRoutes.redeemVoucher,
    name: 'redeemVoucher',
    builder: (context, state) {
      final args = state.extra is RedeemVoucherRouteArgs
          ? state.extra as RedeemVoucherRouteArgs
          : null;
      return RedeemVoucherScreen(routeArgs: args);
    },
  ),
];
