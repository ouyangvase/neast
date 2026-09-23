import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/points/models/points_log_model.dart';

/// 积分收支流水单条列表项。
class PointsHistoryItem extends StatelessWidget {
  const PointsHistoryItem({
    super.key,
    required this.item,
  });

  final PointsLogModel item;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.createdAt,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: brandBlue.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: Colors.black,
                  ),
                ),
                if (item.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 400)],
                      color: brandBlue.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item.pointsLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: brandBlue,
            ),
          ),
        ],
      ),
    );
  }
}
