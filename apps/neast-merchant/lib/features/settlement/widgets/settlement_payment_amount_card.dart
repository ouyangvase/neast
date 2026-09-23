import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/widgets/give_points_white_card.dart';
import 'package:neast/features/settlement/providers/settlement_overview_provider.dart';
import 'package:neast/features/settlement/settlement_colors.dart';

/// 支付页 — 应付金额卡片。
class SettlementPaymentAmountCard extends ConsumerWidget {
  const SettlementPaymentAmountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final amount = ref.watch(settlementOverviewProvider).value?.formattedAmount;

    return GivePointsWhiteCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment amount',
            style: TextStyle(
              fontSize: 12,
              color: SettlementColors.label,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'RM ${amount ?? '-'}',
            style: TextStyle(
              fontSize: 22,
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
