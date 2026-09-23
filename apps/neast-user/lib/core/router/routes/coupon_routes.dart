import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/coupon/models/coupon_detail_args.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/pages/coupon_detail_screen.dart';
import 'package:neast/features/coupon/pages/coupon_screen.dart';
import 'package:neast/features/coupon/pages/my_vouchers_screen.dart';

final List<GoRoute> couponRoutes = [
  GoRoute(
    path: AppRoutes.coupon,
    name: 'coupon',
    builder: (context, state) => const CouponScreen(),
    routes: [
      GoRoute(
        path: 'detail',
        name: 'couponDetail',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is CouponDetailArgs) {
            return CouponDetailScreen(
              item: extra.item,
              listCategoryId: extra.listCategoryId,
              fromMyVouchers: extra.fromMyVouchers,
            );
          }
          return CouponDetailScreen(
            item: extra as CouponListItemModel,
            listCategoryId: null,
          );
        },
      ),
      GoRoute(
        path: 'my-vouchers',
        name: 'myVouchers',
        builder: (context, state) => const MyVouchersScreen(),
      ),
    ],
  ),
];
