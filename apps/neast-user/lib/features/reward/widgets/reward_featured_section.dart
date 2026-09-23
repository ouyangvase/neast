import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_detail_args.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/home/widgets/home_section_header.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';
import 'package:neast/features/reward/widgets/reward_featured_coupon_card.dart';

/// Reward 页 Featured Rewards 横向优惠券区块。
class RewardFeaturedSection extends ConsumerWidget {
  const RewardFeaturedSection({super.key});

  static const _categoryId = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final dashboardAsync = ref.watch(rewardDashboardProvider);

    final isLoading = dashboardAsync.isLoading;
    final items = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.featuredRewards,
      orElse: () => const <CouponListItemModel>[],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'Featured Rewards',
          trailing: 'View All',
          onTrailingTap: () => context.push(AppRoutes.coupon),
        ),
        const SizedBox(height: 12),
        if (isLoading && items.isEmpty)
          SizedBox(
            height: RewardFeaturedCouponCard.cardHeight,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: brandBlue,
              ),
            ),
          )
        else if (items.isEmpty)
          _EmptyHint(
            message: 'No rewards available',
            brandBlue: brandBlue,
          )
        else
          SizedBox(
            height: RewardFeaturedCouponCard.cardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return RewardFeaturedCouponCard(
                  item: item,
                  onTap: () => _openDetail(context, item),
                );
              },
            ),
          ),
      ],
    );
  }

  void _openDetail(BuildContext context, CouponListItemModel item) {
    context.push(
      AppRoutes.couponDetail,
      extra: CouponDetailArgs(
        item: item,
        listCategoryId: _categoryId,
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({
    required this.message,
    required this.brandBlue,
  });

  final String message;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13,
            color: brandBlue.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
