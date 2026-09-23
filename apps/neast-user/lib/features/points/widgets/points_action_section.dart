import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/points/data/points_assets.dart';
import 'package:neast/features/points/providers/points_dashboard_provider.dart';
import 'package:neast/features/points/widgets/points_action_card.dart';

/// 积分页快捷操作区域（固定菜单）。
class PointsActionSection extends ConsumerWidget {
  const PointsActionSection({super.key});

  String _voucherSubtitle(int count) {
    if (count <= 0) return 'No vouchers available';
    if (count == 1) return '1 voucher available';
    return '$count vouchers available';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(pointsDashboardProvider);
    final expiring = dashboardAsync.value?.expiring;
    final voucherCount = dashboardAsync.value?.voucherCount;
    final voucherSubtitle = voucherCount == null
        ? '...'
        : _voucherSubtitle(voucherCount);

    return Column(
      children: [
        if (expiring != null) ...[
          PointsActionCard(
            title: expiring.title,
            subtitle: expiring.subtitle,
            iconAsset: PointsAssets.menuIcon1,
            trailingText: 'Use Now',
            bordered: true,
            onTap: () => context.push(AppRoutes.coupon),
          ),
          const SizedBox(height: 10),
        ],
        PointsActionCard(
          title: 'My Vouchers',
          subtitle: voucherSubtitle,
          iconAsset: PointsAssets.menuIcon2,
          showChevron: true,
          onTap: () async {
            await context.push(AppRoutes.myVouchers);
            ref.read(pointsDashboardProvider.notifier).refresh();
          },
        ),
      ],
    );
  }
}
