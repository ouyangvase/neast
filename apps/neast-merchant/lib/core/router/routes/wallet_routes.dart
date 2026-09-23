import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/wallet/models/wallet_payment_args.dart';
import 'package:neast/features/wallet/pages/wallet_pay_h5_webview_page.dart';
import 'package:neast/features/wallet/pages/wallet_payment_screen.dart';
import 'package:neast/features/wallet/pages/wallet_screen.dart';

final List<GoRoute> walletRoutes = [
  GoRoute(
    path: AppRoutes.wallet,
    name: 'wallet',
    builder: (context, state) => const WalletScreen(),
    routes: [
      GoRoute(
        path: 'payment',
        name: 'walletPayment',
        builder: (context, state) {
          final args = state.extra;
          if (args is WalletPaymentArgs) {
            return WalletPaymentScreen(args: args);
          }
          return WalletPaymentScreen(
            args: WalletPaymentArgs(
              amount: 500,
              amountLabel: 'RM 500',
            ),
          );
        },
      ),
    ],
  ),
  GoRoute(
    path: AppRoutes.payH5WebView,
    name: 'payH5WebView',
    builder: (context, state) {
      final extra = state.extra;
      if (extra is Map<String, dynamic>) {
        return WalletPayH5WebViewPage(
          url: extra['url'] as String? ?? '',
          title: extra['title'] as String? ?? 'Payment',
        );
      }
      return const WalletPayH5WebViewPage(url: '', title: 'Payment');
    },
  ),
];
