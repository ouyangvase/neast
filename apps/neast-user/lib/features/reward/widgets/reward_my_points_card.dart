import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';

/// Reward 页 My Points 卡片。
class RewardMyPointsCard extends ConsumerWidget {
  const RewardMyPointsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(rewardDashboardProvider);
    final pointsText = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.pointsDisplay,
      orElse: () => '-',
    );
    final expiringText = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.pointsExpiringText,
      orElse: () => '',
    );

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 13, top: 13, bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFBF6DA),
            Color(0xFFFBDCAC),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Points',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Colors.black,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pointsText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 600)],
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2, left: 5),
                      child: Text(
                        'points',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 600)],
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                if (expiringText.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    expiringText,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 400)],
                      color: Color(0xFF895A1B),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Image.asset(
            'assets/images/reward/my-points-icon.png',
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
