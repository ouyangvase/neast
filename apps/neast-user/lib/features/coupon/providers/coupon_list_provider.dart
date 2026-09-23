import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_family_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/coupon/models/coupon_category_model.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/services/coupon_service.dart';

/// 优惠券分类列表。
final couponCategoriesProvider = FutureProvider<List<CouponCategoryModel>>((ref) {
  return ref.read(couponServiceProvider).fetchCategories();
});

class CouponListNotifier
    extends PaginatedListFamilyNotifier<CouponListItemModel, int?> {
  CouponListNotifier(super.arg);

  @override
  int get initialPageSize => 10;

  @override
  Future<List<CouponListItemModel>> fetchPage(int page, int pageSize) {
    return ref.read(couponServiceProvider).fetchList(
          categoryId: arg,
          page: page,
          limit: pageSize,
        );
  }
}

/// 优惠券分页列表（family：null = All）。
final couponListProvider = NotifierProvider.family<
    CouponListNotifier,
    PaginatedListState<CouponListItemModel>,
    int?>(CouponListNotifier.new);

/// 优惠券兑换操作。
final couponRedeemProvider = Provider<CouponRedeem>((ref) {
  return CouponRedeem(ref);
});

class CouponRedeem {
  CouponRedeem(this._ref);

  final Ref _ref;

  Future<CouponListItemModel> redeem(int couponId) {
    return _ref.read(couponServiceProvider).redeem(couponId);
  }
}
