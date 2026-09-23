import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/notification/pages/notification_screen.dart';

final List<GoRoute> notificationRoutes = [
  GoRoute(
    path: AppRoutes.notification,
    name: 'notification',
    builder: (context, state) => const NotificationScreen(),
  ),
];
