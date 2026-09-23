import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/transaction/pages/transaction_history_screen.dart';

final List<GoRoute> transactionRoutes = [
  GoRoute(
    path: AppRoutes.transactionHistory,
    name: 'transactionHistory',
    builder: (context, state) => const TransactionHistoryScreen(),
  ),
];
