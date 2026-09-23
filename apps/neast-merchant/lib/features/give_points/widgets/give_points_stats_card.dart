import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_assets.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/give_points/providers/give_points_today_stats_provider.dart';

class _StatItem {
  const _StatItem({
    required this.iconAsset,
    required this.label,
    required this.value,
    this.currencyPrefix,
  });

  final String iconAsset;
  final String label;
  final String value;
  final String? currencyPrefix;
}

/// 今日统计四列卡片。
class GivePointsStatsCard extends ConsumerWidget {
  const GivePointsStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final stats = ref.watch(givePointsTodayStatsProvider).value;

    final statItems = [
      _StatItem(
        iconAsset: GivePointsAssets.stat1,
        label: 'Customers\nToday',
        value: stats?.formattedCustomersToday ?? '-',
      ),
      _StatItem(
        iconAsset: GivePointsAssets.stat2,
        label: 'Avg\nSpend',
        currencyPrefix: 'RM',
        value: stats?.formattedAvgSpend ?? '-',
      ),
      _StatItem(
        iconAsset: GivePointsAssets.stat3,
        label: 'Points\nToday',
        value: stats?.formattedPointsToday ?? '-',
      ),
      _StatItem(
        iconAsset: GivePointsAssets.stat4,
        label: 'Repeat\nCust',
        value: stats?.formattedRepeatCustomers ?? '-',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < statItems.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: brandBlue.withValues(alpha: 0.12),
                ),
              Expanded(child: _StatColumn(item: statItems[i], brandBlue: brandBlue)),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.item,
    required this.brandBlue,
  });

  final _StatItem item;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            item.iconAsset,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 10,
              height: 1.2,
              color: GivePointsColors.label,
            ),
          ),
          const SizedBox(height: 8),
          _StatValue(item: item, brandBlue: brandBlue),
        ],
      ),
    );
  }
}

class _StatValue extends StatelessWidget {
  const _StatValue({
    required this.item,
    required this.brandBlue,
  });

  final _StatItem item;
  final Color brandBlue;

  static const _valueFontSize = 14.0;
  static const _currencyFontSize = 8.0;

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      fontSize: _valueFontSize,
      fontFamily: 'FD',
      fontVariations: [FontVariation('wght', 500)],
      color: brandBlue,
    );

    if (item.currencyPrefix != null) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${item.currencyPrefix} ',
              style: valueStyle.copyWith(fontSize: _currencyFontSize),
            ),
            TextSpan(text: item.value, style: valueStyle),
          ],
        ),
      );
    }

    return Text(item.value, style: valueStyle);
  }
}
