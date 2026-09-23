import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/core/widgets/app_refresher.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/utils/coupon_icon_utils.dart';
import 'package:neast/features/coupon/widgets/coupon_reward_card.dart';

/// 优惠券奖励列表（可下拉刷新 / 上拉加载）。
class CouponRewardListView extends StatelessWidget {
  const CouponRewardListView({
    super.key,
    required this.brandBlue,
    required this.listState,
    required this.refreshController,
    required this.onRefresh,
    required this.onLoad,
    required this.onItemTap,
    this.emptyText = 'No coupons available',
  });

  final Color brandBlue;
  final PaginatedListState<CouponListItemModel> listState;
  final EasyRefreshController refreshController;
  final Future<void> Function() onRefresh;
  final Future<bool> Function() onLoad;
  final void Function(CouponListItemModel item) onItemTap;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final items = listState.list;

    if (items.isEmpty) {
      return AppRefresher(
        controller: refreshController,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: Center(
                child: Text(
                  emptyText,
                  style: TextStyle(
                    fontSize: 13,
                    color: brandBlue.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final itemCount = items.length + (listState.hasMore ? 0 : 1);

    return AppRefresher(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, index) {
          if (index >= items.length - 1) {
            return const SizedBox(height: 16);
          }
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          if (index == items.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "That's all for now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: brandBlue.withValues(alpha: 0.4),
                ),
              ),
            );
          }

          final item = items[index];
          final iconStyle = couponIconStyleFor(item.id);

          return CouponRewardCard(
            item: item,
            icon: iconStyle.icon,
            iconColor: iconStyle.color,
            onTap: () => onItemTap(item),
          );
        },
      ),
    );
  }
}
