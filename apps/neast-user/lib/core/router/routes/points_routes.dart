import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/points/pages/points_history_screen.dart';
import 'package:neast/features/points/pages/points_screen.dart';

final List<GoRoute> pointsRoutes = [
  GoRoute(
    path: AppRoutes.points,
    name: 'points',
    builder: (context, state) => const PointsScreen(),
  ),
  GoRoute(
    path: AppRoutes.pointsHistory,
    name: 'pointsHistory',
    builder: (context, state) => const PointsHistoryScreen(),
  ),
];
