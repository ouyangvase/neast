import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/refer/providers/refer_dashboard_provider.dart';

/// 推荐页顶部统计卡片。
class ReferStatsCard extends ConsumerWidget {
  const ReferStatsCard({super.key});

  static const _icons = [
    'assets/images/refer/stats-icon1.png',
    'assets/images/refer/stats-icon2.png',
    'assets/images/refer/stats-icon3.png',
  ];

  static const _labels = [
    'Total Earned',
    'Invites',
    'Next Reward',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final dashboardAsync = ref.watch(referDashboardProvider);

    final values = dashboardAsync.maybeWhen(
      data: (dashboard) => [
        dashboard.totalEarnedLabel,
        dashboard.invitesLabel,
        dashboard.nextRewardLabel,
      ],
      orElse: () => ['-', '-', '-'],
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: List.generate(_labels.length, (index) {
          final icon = _icons[index];
          final value = values[index];
          final label = _labels[index];
          return Expanded(
            child: Row(
              children: [
                if (index > 0)
                  Container(
                    width: 1,
                    height: 48,
                    color: brandBlue.withValues(alpha: 0.1),
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(icon, width: 12, height: 12),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HG',
                              fontVariations: [FontVariation('wght', 500)],
                              color: brandBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 9,
                              color: brandBlue.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
