import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/points/providers/points_dashboard_provider.dart';
import 'package:neast/features/points/data/points_assets.dart';

/// 积分页主卡片：积分摘要。
class PointsSummaryCard extends ConsumerWidget {
  const PointsSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(pointsDashboardProvider);
    final pointsAmount = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.pointsDisplay,
      orElse: () => '-',
    );
    final tierLabel = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.tierLabel,
      orElse: () => '- tier',
    );

    return GestureDetector(
      onTap: () => context.push(AppRoutes.pointsHistory),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: const DecorationImage(
            image: AssetImage(PointsAssets.funcBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'neast',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: 'points',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  tierLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: pointsAmount,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const TextSpan(
                        text: ' pts',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
