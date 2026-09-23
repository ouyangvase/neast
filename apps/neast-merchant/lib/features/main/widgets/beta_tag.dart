import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// Beta 标签总开关：true 显示，false 全部隐藏。
const bool kShowBetaTag = true;

/// Header 用 Beta 小标签（蓝边蓝字，白底便于深浅背景都可见）。
class BetaTag extends StatelessWidget {
  const BetaTag({super.key});

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: brandBlue, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'beta',
        style: TextStyle(
          color: brandBlue,
          fontSize: 10,
          height: 1.1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
