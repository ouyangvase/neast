import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/refer/pages/refer_screen.dart';

final List<GoRoute> referRoutes = [
  GoRoute(
    path: AppRoutes.refer,
    name: 'refer',
    builder: (context, state) => const ReferScreen(),
  ),
];
