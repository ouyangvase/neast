import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 积分页快捷操作卡片（过期积分 / 优惠券等）。
class PointsActionCard extends StatelessWidget {
  const PointsActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    this.trailingText,
    this.showChevron = false,
    this.bordered = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String iconAsset;
  final String? trailingText;
  final bool showChevron;
  final bool bordered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: bordered
              ? Border.all(
                  color: brandBlue.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
          boxShadow: bordered
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Image.asset(
                iconAsset,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: brandBlue.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (trailingText != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailingText!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: brandBlue,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: brandBlue.withValues(alpha: 0.6),
                  ),
                ],
              )
            else if (showChevron)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: brandBlue.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
