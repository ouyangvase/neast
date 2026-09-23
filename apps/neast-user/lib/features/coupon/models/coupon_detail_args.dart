import 'package:neast/features/coupon/models/coupon_list_item_model.dart';

/// 优惠券详情页路由参数。
class CouponDetailArgs {
  const CouponDetailArgs({
    required this.item,
    this.listCategoryId,
    this.fromMyVouchers = false,
  });

  final CouponListItemModel item;

  /// 进入详情时列表页选中的分类（null = All）。
  final int? listCategoryId;

  /// 是否从「My Vouchers」页进入。
  final bool fromMyVouchers;
}
