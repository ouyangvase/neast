import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/daily_closing/pages/daily_closing_screen.dart';

final List<GoRoute> dailyClosingRoutes = [
  GoRoute(
    path: AppRoutes.dailyClosing,
    name: 'dailyClosing',
    builder: (context, state) => const DailyClosingScreen(),
  ),
];
