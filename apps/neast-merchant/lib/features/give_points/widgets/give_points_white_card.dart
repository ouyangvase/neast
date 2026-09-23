import 'package:flutter/material.dart';

/// Give Points 流程通用白卡片（圆角 12）。
class GivePointsWhiteCard extends StatelessWidget {
  const GivePointsWhiteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  static BoxDecoration decoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          offset: Offset(0, 2),
          blurRadius: 8,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration(),
      padding: padding,
      child: child,
    );
  }
}
