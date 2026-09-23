import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_assets.dart';

/// 积分预览卡片。
class ReceiptPointsPreviewCard extends StatelessWidget {
  const ReceiptPointsPreviewCard({
    super.key,
    required this.amountText,
    required this.yuanToPoints,
  });

  final String amountText;
  final int yuanToPoints;

  int get _points {
    final amount = double.tryParse(amountText.replaceAll(',', '').trim()) ?? 0;
    if (yuanToPoints <= 0) {
      return 0;
    }
    return (amount * yuanToPoints).round();
  }

  String get _displayAmount {
    final amount = double.tryParse(amountText.replaceAll(',', '').trim());
    if (amount == null) {
      return amountText.isEmpty ? '0.00' : amountText;
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1029 / 300,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(GivePointsAssets.pointsPreview),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26E8920B),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Text(
            'You will give',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_points',
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'FD',
                  fontVariations: [FontVariation('wght', 500)],
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                ' pts',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Based on RM$_displayAmount × $yuanToPoints pts/RM 1',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.3,
            ),
          ),
        ],
        ),
      ),
    );
  }
}

/// Points Preview 区块标题 + 卡片。
class ReceiptPointsPreviewSection extends StatelessWidget {
  const ReceiptPointsPreviewSection({
    super.key,
    required this.amountText,
    required this.yuanToPoints,
  });

  final String amountText;
  final int yuanToPoints;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Points Preview',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'FD',
            fontVariations: [FontVariation('wght', 500)],
            color: brandBlue,
          ),
        ),
        const SizedBox(height: 10),
        ReceiptPointsPreviewCard(
          amountText: amountText,
          yuanToPoints: yuanToPoints,
        ),
      ],
    );
  }
}
