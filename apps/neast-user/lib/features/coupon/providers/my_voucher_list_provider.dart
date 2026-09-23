import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_family_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/services/coupon_service.dart';

/// 我的可用优惠券数量（未使用且未过期）。
final myVoucherCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.read(couponServiceProvider).fetchMyCount();
});

class MyVoucherListNotifier
    extends PaginatedListFamilyNotifier<CouponListItemModel, MyVoucherStatus> {
  MyVoucherListNotifier(super.arg);

  @override
  int get initialPageSize => 10;

  @override
  Future<List<CouponListItemModel>> fetchPage(int page, int pageSize) {
    return ref.read(couponServiceProvider).fetchMyList(
          status: arg,
          page: page,
          limit: pageSize,
        );
  }
}

/// 我的优惠券分页列表（family：按 Tab 状态筛选）。
final myVoucherListProvider = NotifierProvider.family<
    MyVoucherListNotifier,
    PaginatedListState<CouponListItemModel>,
    MyVoucherStatus>(MyVoucherListNotifier.new);
