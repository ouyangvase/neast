import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/give_points/providers/give_points_today_commission_provider.dart';

/// 今日最佳门店卡片。
class GivePointsOutletCard extends ConsumerWidget {
  const GivePointsOutletCard({super.key});

  void _openDailyClosing(BuildContext context) {
    context.push(AppRoutes.dailyClosing);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final info = ref.watch(merchantInfoProvider).value;
    final commissionRm = ref
            .watch(givePointsTodayCommissionProvider)
            .value
            ?.formattedCommission ??
        '0.00';

    return GestureDetector(
      onTap: () => _openDailyClosing(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Outlet Today',
                    style: TextStyle(
                      fontSize: 12,
                      color: GivePointsColors.label,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    info?.name ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'FD',
                      fontVariations: [FontVariation('wght', 500)],
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'RM $commissionRm',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'FD',
                      fontVariations: [FontVariation('wght', 500)],
                      color: brandBlue,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Closing',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: brandBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
