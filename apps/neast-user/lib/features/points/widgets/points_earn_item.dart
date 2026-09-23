import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 积分页 How to Earn Faster 列表项。
class PointsEarnItem extends StatelessWidget {
  const PointsEarnItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    this.highlight,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String iconAsset;
  final String? highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
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
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Image.asset(
                iconAsset,
                width: 44,
                height: 44,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: brandBlue.withValues(alpha: 0.5),
                    ),
                  ),
                  if (highlight != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      highlight!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFD4A017),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
