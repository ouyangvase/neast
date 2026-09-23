import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/pages/owner_invite_screen.dart';
import 'package:neast/features/pay_rent/pages/pay_rent_create_screen.dart';
import 'package:neast/features/pay_rent/pages/pay_rent_detail_screen.dart';
import 'package:neast/features/pay_rent/pages/pay_rent_payment_screen.dart';
import 'package:neast/features/pay_rent/pages/rent_payment_status_screen.dart';
import 'package:neast/features/pay_rent/pages/rent_history_screen.dart';

final List<GoRoute> payRentRoutes = [
  GoRoute(
    path: AppRoutes.payRentPayment,
    name: 'payRentPayment',
    builder: (context, state) {
      return PayRentPaymentScreen(
        rent: state.extra! as RentModel,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.payRentDetail,
    name: 'payRentDetail',
    builder: (context, state) {
      return PayRentDetailScreen(
        rent: state.extra! as RentModel,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.payRentCreate,
    name: 'payRentCreate',
    builder: (context, state) => const PayRentCreateScreen(),
  ),
  GoRoute(
    path: AppRoutes.rentHistory,
    name: 'rentHistory',
    builder: (context, state) => const RentHistoryScreen(),
  ),
  GoRoute(
    path: AppRoutes.rentHistoryDetail,
    name: 'rentHistoryDetail',
    builder: (context, state) {
      return RentPaymentStatusScreen(
        item: state.extra! as RentHistoryModel,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.ownerInvite,
    name: 'ownerInvite',
    builder: (context, state) {
      return OwnerInviteScreen(
        args: state.extra! as OwnerInviteArgs,
      );
    },
  ),
];
