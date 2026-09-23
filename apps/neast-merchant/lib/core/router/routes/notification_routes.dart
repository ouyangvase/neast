import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/notification/pages/notification_screen.dart';

final List<GoRoute> notificationRoutes = [
  GoRoute(
    path: AppRoutes.notification,
    name: 'notification',
    builder: (context, state) => const NotificationScreen(),
  ),
];
