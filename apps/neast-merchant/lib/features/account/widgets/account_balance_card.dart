import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:neast/features/account/account_assets.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';

/// Account 页面余额卡片：橙色渐变 + 钱包余额 + 金币图标。
class AccountBalanceCard extends ConsumerWidget {
  const AccountBalanceCard({super.key});

  static final NumberFormat _amountFormat = NumberFormat('#,##0.00', 'en_US');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchant = ref.watch(merchantInfoProvider).value;
    final balance = double.tryParse(merchant?.balance ?? '') ?? 0;

    return Container(
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment(-0.67, -0.74),
          end: Alignment(0.67, 0.74),
          colors: [
            Color(0xFFFFF8EC),
            Color(0xFFECB87D),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              AccountAssets.coin,
              width: 60,
              height: 55,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE3A86D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'RM${_amountFormat.format(balance)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Color(0xFFE3A86D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
