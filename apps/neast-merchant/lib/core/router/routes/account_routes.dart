import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/account/pages/invoice_screen.dart';
import 'package:neast/features/account/pages/store_profile_screen.dart';

final List<GoRoute> accountRoutes = [
  GoRoute(
    path: AppRoutes.storeProfile,
    name: 'storeProfile',
    builder: (context, state) => const StoreProfileScreen(),
  ),
  GoRoute(
    path: AppRoutes.invoice,
    name: 'invoice',
    builder: (context, state) => const InvoiceScreen(),
  ),
];
