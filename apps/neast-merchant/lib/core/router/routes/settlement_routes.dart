import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/settlement/pages/settlement_payment_screen.dart';

final List<GoRoute> settlementRoutes = [
  GoRoute(
    path: AppRoutes.settlementPayment,
    name: 'settlementPayment',
    builder: (context, state) => const SettlementPaymentScreen(),
  ),
];
