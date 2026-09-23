import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/account/pages/bank_detail_screen.dart';

final List<GoRoute> accountRoutes = [
  GoRoute(
    path: AppRoutes.bankDetail,
    name: 'bankDetail',
    builder: (context, state) => const BankDetailScreen(),
  ),
];
