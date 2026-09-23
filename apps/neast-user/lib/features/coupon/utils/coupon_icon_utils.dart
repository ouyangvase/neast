import 'package:flutter/material.dart';

class CouponIconStyle {
  const CouponIconStyle({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}

/// 按优惠券 id 从固定图标池取稳定样式。
CouponIconStyle couponIconStyleFor(int couponId) {
  const styles = [
    CouponIconStyle(icon: Icons.delivery_dining, color: Color(0xFF00B14F)),
    CouponIconStyle(icon: Icons.coffee, color: Color(0xFF00704A)),
    CouponIconStyle(icon: Icons.flight, color: Color(0xFFE4002B)),
    CouponIconStyle(icon: Icons.shopping_bag, color: Color(0xFF6C5CE7)),
    CouponIconStyle(icon: Icons.local_offer, color: Color(0xFFF5A623)),
    CouponIconStyle(icon: Icons.card_giftcard, color: Color(0xFF0851AA)),
  ];

  return styles[couponId.abs() % styles.length];
}
