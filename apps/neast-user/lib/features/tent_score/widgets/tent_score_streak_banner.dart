import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// Tent Score 连续缴租横条（浅绿背景）。
class TentScoreStreakBanner extends StatelessWidget {
  const TentScoreStreakBanner({
    super.key,
    required this.streakLabel,
    required this.streakStatus,
  });

  final String streakLabel;
  final String streakStatus;

  @override
  Widget build(BuildContext context) {
    final green = context.appColors.darkGreen;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            streakLabel,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'HG',
              fontVariations: const [FontVariation('wght', 700)],
              color: green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            streakStatus,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'HG',
              fontVariations: const [FontVariation('wght', 500)],
              color: green,
            ),
          ),
        ],
      ),
    );
  }
}
