import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/home/models/ack_item_model.dart';
import 'package:neast_landlords/features/home/pages/ack_detail_screen.dart';
import 'package:neast_landlords/features/home/pages/ack_list_screen.dart';

final List<GoRoute> ackRoutes = [
  GoRoute(
    path: AppRoutes.ackList,
    name: 'ackList',
    builder: (context, state) => const AckListScreen(),
  ),
  GoRoute(
    path: AppRoutes.ackDetail,
    name: 'ackDetail',
    builder: (context, state) {
      final item = state.extra as AckItemModel? ?? const AckItemModel(
        initials: 'SK',
        name: 'Sarah K',
        amount: '1,800',
        paidText: 'Paid om',
        paidDate: 'March 25.2025',
        propertyName: 'Property Hopes',
        propertyAddress: '17A, R&F tower 2, Johor Bahru',
        rentalDate: '5 January 2026',
      );
      return AckDetailScreen(item: item);
    },
  ),
];
