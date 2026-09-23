import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_assets.dart';
import 'package:neast/features/give_points/providers/points_setting_provider.dart';

/// 积分规则卡片。
class GivePointsEarnRuleCard extends ConsumerWidget {
  const GivePointsEarnRuleCard({super.key});

  static const _backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE9F2FC),
      Color(0xFF78ACDE),
    ],
  );

  static const _descriptionLines = [
    'Standard rate.',
    'Bonus events may apply',
    'during campaigns.',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final yuanToPoints = ref.watch(pointsSettingProvider).value?.yuanToPoints;
    final rateText = yuanToPoints != null && yuanToPoints > 0
        ? '$yuanToPoints pts / RM1'
        : '-- pts / RM1';
    final descriptionStyle = TextStyle(
      fontSize: 11,
      height: 1.35,
      color: brandBlue.withValues(alpha: 0.55),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: _backgroundGradient,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Earn Rule',
                style: TextStyle(
                  fontSize: 12,
                  color: brandBlue.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rateText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 6),
              for (final line in _descriptionLines)
                Text(line, style: descriptionStyle),
              const SizedBox(height: 24),
            ],
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Image.asset(
              GivePointsAssets.ruleIcon,
              width: 66,
              height: 66,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
