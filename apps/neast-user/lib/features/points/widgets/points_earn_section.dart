import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/points/data/points_assets.dart';
import 'package:neast/features/points/providers/points_dashboard_provider.dart';
import 'package:neast/features/points/widgets/points_earn_item.dart';

/// 积分页 How to Earn Faster 区域（固定菜单）。
class PointsEarnSection extends ConsumerWidget {
  const PointsEarnSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(pointsDashboardProvider);
    final referralSubtitle = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.referralSubtitle,
      orElse: () => '...',
    );
    final referralHighlight = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.referralHighlight,
      orElse: () => '...',
    );

    return Column(
      children: [
        const PointsEarnItem(
          title: 'Pay Rent & Earn',
          subtitle: 'Earn up to 2000 pts per payment',
          iconAsset: PointsAssets.menuIcon3,
        ),
        const SizedBox(height: 10),
        PointsEarnItem(
          title: 'Refer Friends & Earn',
          subtitle: referralSubtitle,
          iconAsset: PointsAssets.menuIcon4,
          highlight: referralHighlight,
          onTap: () => context.push(AppRoutes.refer),
        ),
      ],
    );
  }
}
