import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/home/models/bind_request_item_model.dart';
import 'package:neast_landlords/features/home/pages/bind_request_detail_screen.dart';
import 'package:neast_landlords/features/home/pages/bind_request_list_screen.dart';

final List<GoRoute> bindRequestRoutes = [
  GoRoute(
    path: AppRoutes.bindRequestList,
    name: 'bindRequestList',
    builder: (context, state) => const BindRequestListScreen(),
  ),
  GoRoute(
    path: AppRoutes.bindRequestDetail,
    name: 'bindRequestDetail',
    builder: (context, state) {
      final item = state.extra as BindRequestItemModel;
      return BindRequestDetailScreen(item: item);
    },
  ),
];
