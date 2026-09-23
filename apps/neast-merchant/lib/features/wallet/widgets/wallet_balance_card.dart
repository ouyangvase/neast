import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/wallet/data/wallet_config.dart';

/// 钱包余额卡片。
class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.balance,
  });

  final String balance;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RM $balance',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your balance',
                  style: TextStyle(
                    fontSize: 13,
                    color: brandBlue.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            WalletAssets.balanceIcon,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
