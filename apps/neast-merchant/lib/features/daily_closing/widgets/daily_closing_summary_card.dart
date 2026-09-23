import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/daily_closing/daily_closing_assets.dart';
import 'package:neast/features/daily_closing/daily_closing_constants.dart';
import 'package:neast/features/daily_closing/providers/daily_closing_summary_provider.dart';

class _SummaryStat {
  const _SummaryStat({
    required this.iconAsset,
    required this.label,
    required this.value,
  });

  final String iconAsset;
  final String label;
  final String value;
}

/// 今日销售汇总卡片。
class DailyClosingSummaryCard extends ConsumerWidget {
  const DailyClosingSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final summaryAsync = ref.watch(dailyClosingSummaryProvider);
    final summary = summaryAsync.value;

    final stats = [
      _SummaryStat(
        iconAsset: DailyClosingAssets.stat1,
        label: 'Redeemed',
        value: summary?.formattedRedeemed ?? '-',
      ),
      _SummaryStat(
        iconAsset: DailyClosingAssets.stat2,
        label: 'Points',
        value: summary?.formattedPoints ?? '-',
      ),
      _SummaryStat(
        iconAsset: DailyClosingAssets.stat3,
        label: 'Customers',
        value: summary?.formattedCustomers ?? '-',
      ),
    ];

    final commissionDisplay = summary?.formattedCommission ?? '-';

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Sales",
                  style: TextStyle(
                    fontSize: 12,
                    color: DailyClosingColors.salesAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  commissionDisplay == '-'
                      ? '-'
                      : 'RM $commissionDisplay',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                    color: DailyClosingColors.salesAccent,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < stats.length; i++) ...[
                    if (i > 0) ...[
                      const SizedBox(width: 30),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: brandBlue.withValues(alpha: 0.12),
                      ),
                      const SizedBox(width: 21),
                    ],
                    _SummaryStatColumn(
                      item: stats[i],
                      brandBlue: brandBlue,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatColumn extends StatelessWidget {
  const _SummaryStatColumn({
    required this.item,
    required this.brandBlue,
  });

  final _SummaryStat item;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          item.iconAsset,
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          style: const TextStyle(
            fontSize: 12,
            height: 1.2,
            color: DailyClosingColors.label,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'FD',
            fontVariations: [FontVariation('wght', 500)],
            color: brandBlue,
          ),
        ),
      ],
    );
  }
}
