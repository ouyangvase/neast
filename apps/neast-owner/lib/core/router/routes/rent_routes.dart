import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/home/models/rent_item_model.dart';
import 'package:neast_landlords/features/home/pages/rent_detail_screen.dart';

final List<GoRoute> rentRoutes = [
  GoRoute(
    path: AppRoutes.rentDetail,
    name: 'rentDetail',
    builder: (context, state) {
      final item = state.extra as RentItemModel? ?? const RentItemModel(
        initials: 'NF',
        name: 'Nur Farhana',
        address: 'The Oak B-12-02',
        statusText: '14 Days late',
        amount: '1,600',
        propertyName: 'Property Hopes',
        propertyAddress: '17A, R&F tower 2, Johor Bahru',
        rentalDate: '5 January 2026',
        status: RentStatus.overdue,
      );
      return RentDetailScreen(item: item);
    },
  ),
];
