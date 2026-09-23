import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 优惠券详情页积分横幅。
class CouponDetailPointsBanner extends StatelessWidget {
  const CouponDetailPointsBanner({
    super.key,
    required this.requiredPoints,
  });

  static const _backgroundColor = Color(0xFFFFF8EA);
  static const _textColor = Color(0xFF895A1B);

  final int requiredPoints;

  @override
  Widget build(BuildContext context) {
    final pointsText = NumberFormat('#,###').format(requiredPoints);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                pointsText,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 600)],
                  color: _textColor,
                ),
              ),
              const Text(
                'POINTS',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  letterSpacing: 0.5,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'VOUCHER',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 700)],
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}
