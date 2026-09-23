import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 首页区块标题行，左侧标题 + 右侧箭头按钮或文字链接。
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 500)],
            color: Colors.black,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              trailing!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: brandBlue.withValues(alpha: 0.7),
              ),
            ),
          )
        else
          GestureDetector(
            onTap: onTrailingTap,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: brandBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: brandBlue,
              ),
            ),
          ),
      ],
    );
  }
}
