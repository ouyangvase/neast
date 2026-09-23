import 'package:flutter/material.dart';

/// 个人资料表单白色卡片（阴影、无边框）。
class ProfileFormCard extends StatelessWidget {
  const ProfileFormCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  static const decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
        color: Color(0x0D000000),
        offset: Offset(0, 2),
        blurRadius: 8,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: decoration,
      padding: padding,
      child: child,
    );
  }
}
