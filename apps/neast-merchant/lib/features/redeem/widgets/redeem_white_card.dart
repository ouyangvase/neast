import 'package:flutter/material.dart';

/// 兑换页通用白色卡片容器。
class RedeemWhiteCard extends StatelessWidget {
  const RedeemWhiteCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}
