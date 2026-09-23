import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 积分展示：数字 22px + pts 12px。
class PointsValueText extends StatelessWidget {
  const PointsValueText({
    super.key,
    required this.points,
    this.suffix = 'pts',
    this.color,
  });

  final int points;
  final String suffix;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? context.appColors.brandBlue;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$points',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.1,
          ),
        ),
        Text(
          suffix,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
