import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 付款页顶部充值金额摘要卡片。
class WalletTopupAmountSummaryCard extends StatelessWidget {
  const WalletTopupAmountSummaryCard({
    super.key,
    required this.amountLabel,
  });

  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top-up amount',
            style: TextStyle(
              fontSize: 13,
              color: brandBlue.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amountLabel,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: brandBlue,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
