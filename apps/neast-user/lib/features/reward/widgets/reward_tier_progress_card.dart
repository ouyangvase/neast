import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/reward/data/reward_tier_constants.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';

/// Reward 页 Gold Tenant 进度卡片。
class RewardTierProgressCard extends ConsumerWidget {
  const RewardTierProgressCard({super.key});

  static const _borderColor = Color(0xFF3260BA);
  static const _gradientStart = Color(0xFF234FA5);
  static const _gradientEnd = Color(0xFF022468);

  /// CSS `linear-gradient(153deg, ...)` → Flutter [Alignment]。
  static Alignment _cssGradientAlignment(double degrees) {
    final radians = degrees * math.pi / 180;
    return Alignment(math.sin(radians), -math.cos(radians));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(rewardDashboardProvider);
    final tier = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.tier,
      orElse: () => null,
    );

    final tierName = tier?.current.displayName ?? '-';
    final progress = tier?.progress ?? 0;
    final progressLabel = tier?.progressPointsLabel ?? '-/- pts';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        gradient: LinearGradient(
          begin: _cssGradientAlignment(153 + 180),
          end: _cssGradientAlignment(153),
          colors: const [_gradientStart, _gradientEnd],
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
                  tierName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Next Tier',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFE8C547)),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  progressLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            RewardTierConstants.goldIconAsset,
            width: 56,
            height: 56,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
