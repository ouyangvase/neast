import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/home/widgets/deal_card.dart';
import 'package:neast/features/home/widgets/home_merchant_section_skeleton.dart';
import 'package:neast/features/home/widgets/home_section_header.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';

/// Reward 页 Nearby Rewards 横向商家区块。
class RewardNearbySection extends ConsumerWidget {
  const RewardNearbySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final dashboardAsync = ref.watch(rewardDashboardProvider);
    final notifier = ref.read(rewardDashboardProvider.notifier);

    final isLoading = dashboardAsync.isLoading;
    final items = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.nearbyRewards,
      orElse: () => const [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'Nearby Rewards',
          trailing: 'View All',
          onTrailingTap: () => context.push(AppRoutes.merchantMapRoute()),
        ),
        const SizedBox(height: 10),
        if (notifier.locationUnavailable)
          _EmptyHint(
            message: 'Enable location to see nearby merchants',
            brandBlue: brandBlue,
          )
        else if (isLoading && items.isEmpty)
          SizedBox(
            height: DealCard.listItemHeight,
            child: const HomeDealCardsSkeleton(),
          )
        else if (items.isEmpty)
          _EmptyHint(
            message: 'No nearby merchants',
            brandBlue: brandBlue,
          )
        else
          SizedBox(
            height: DealCard.listItemHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final merchant = items[index];
                return DealCard(
                  merchant: merchant,
                  onTap: () => context.push(AppRoutes.merchantDetail(merchant.id)),
                );
              },
            ),
          ),
      ],
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
    return SizedBox(
      height: DealCard.listItemHeight,
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13,
            color: brandBlue.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
