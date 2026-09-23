import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/home/pages/portfolio_snapshot_screen.dart';
import 'package:neast_landlords/features/home/pages/portfolio_tenant_detail_screen.dart';

final List<GoRoute> portfolioRoutes = [
  GoRoute(
    path: AppRoutes.portfolioSnapshot,
    name: 'portfolioSnapshot',
    builder: (context, state) => const PortfolioSnapshotScreen(),
  ),
  GoRoute(
    path: AppRoutes.portfolioTenantDetail,
    name: 'portfolioTenantDetail',
    builder: (context, state) {
      final rentId = state.extra is int
          ? state.extra! as int
          : int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 0;

      return PortfolioTenantDetailScreen(rentId: rentId);
    },
  ),
];
