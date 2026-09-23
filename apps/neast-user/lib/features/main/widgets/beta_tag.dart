import 'package:flutter/material.dart';

/// Beta 标签总开关：true 显示，false 全部隐藏。
const bool kShowBetaTag = true;

/// Header 用 Beta 小标签（白边白字）。
class BetaTag extends StatelessWidget {
  const BetaTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'beta',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          height: 1.1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
