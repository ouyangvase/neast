import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/redeem/widgets/redeem_white_card.dart';

/// 当班收银员卡片。
class RedeemCashierCard extends StatelessWidget {
  const RedeemCashierCard({super.key});

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return RedeemWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cashier On Duty',
            style: TextStyle(fontSize: 12, color: GivePointsColors.label),
          ),
          const SizedBox(height: 8),
          Text(
            'Mei Yan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sunway Pyramid · STF-204',
            style: TextStyle(fontSize: 12, color: GivePointsColors.label),
          ),
        ],
      ),
    );
  }
}
