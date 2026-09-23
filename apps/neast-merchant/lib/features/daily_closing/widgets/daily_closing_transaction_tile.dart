import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/daily_closing/daily_closing_constants.dart';
import 'package:neast/features/daily_closing/models/daily_closing_transaction_model.dart';
import 'package:neast/features/give_points/utils/give_points_points_util.dart';

class DailyClosingTransactionTile extends StatelessWidget {
  const DailyClosingTransactionTile({
    super.key,
    required this.transaction,
  });

  final DailyClosingTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final amount = GivePointsPointsUtil.formatAmountDisplay(transaction.amount);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            child: Text(
              transaction.time,
              style: const TextStyle(
                fontSize: 12,
                color: DailyClosingColors.label,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt RM$amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  transaction.userName.isEmpty ? '-' : transaction.userName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: DailyClosingColors.label,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.formattedPoints,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 500)],
              color: brandBlue,
            ),
          ),
        ],
      ),
    );
  }
}
