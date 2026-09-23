import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// 首页分区标题（可选「View All」入口）。
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.actionText = 'View All',
  });

  final String title;
  final VoidCallback? onViewAll;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 500)],
              color: brandBlue,
            ),
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: brandBlue,
                  ),
                ),
                Icon(Icons.chevron_right, size: 18, color: brandBlue),
              ],
            ),
          ),
      ],
    );
  }
}
