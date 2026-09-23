import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/providers/rent_history_provider.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_card_shadow.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_history_item.dart';

/// Pay Rent 最近支付区块：单张白卡片内含标题与最多 5 条记录。
class PayRentHistorySection extends ConsumerWidget {
  const PayRentHistorySection({super.key});

  static const _maxItems = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final historyAsync = ref.watch(payRentRecentHistoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: PayRentCardShadow.boxShadow,
      ),
      child: historyAsync.when(
        data: (history) => _buildContent(context, history, brandBlue),
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => _buildContent(context, const [], brandBlue),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<RentHistoryModel> history,
    Color brandBlue,
  ) {
    final items = history.take(_maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              const Text(
                'Recent Payments',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push(AppRoutes.rentHistory),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (items.isEmpty)
          _buildEmpty(brandBlue)
        else
          Column(
            children: [
              for (var i = 0; i < items.length; i++)
                PayRentHistoryTile(
                  item: items[i],
                  compact: true,
                  showDivider: false,
                  showStatus: true,
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildEmpty(Color brandBlue) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Center(
        child: Text(
          'No payment history',
          style: TextStyle(
            fontSize: 13,
            color: brandBlue.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
