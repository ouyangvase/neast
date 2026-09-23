import 'package:flutter/material.dart';
import 'package:neast/features/reward/data/reward_tier_constants.dart';
import 'package:neast/features/reward/models/reward_dashboard_model.dart';

/// 奖励等级页当前等级卡片。
class RewardCurrentTierCard extends StatelessWidget {
  const RewardCurrentTierCard({
    super.key,
    required this.tier,
  });

  final RewardTierProgressModel tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 22, 12, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: RewardTierConstants.currentTierCardGradient,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Current Tier',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Color(0xFF895A1B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tier.current.displayName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 700)],
                    color: Color(0xFF895A1B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tier.next != null
                      ? '${tier.progressPointsLabel} to ${tier.nextTierLabel}'
                      : 'Maximum tier reached',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: tier.progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF234FA5),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFE8C547)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            RewardTierConstants.goldIconAsset,
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
