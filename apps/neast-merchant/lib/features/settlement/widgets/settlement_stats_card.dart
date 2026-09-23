import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/settlement/providers/settlement_overview_provider.dart';
import 'package:neast/features/settlement/settlement_assets.dart';
import 'package:neast/features/settlement/settlement_colors.dart';

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

/// Settlement 统计三列卡片。
class SettlementStatsCard extends ConsumerWidget {
  const SettlementStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final overview = ref.watch(settlementOverviewProvider).value;

    final stats = [
      _StatItem(
        iconAsset: SettlementAssets.stat1,
        label: 'Sales',
        currencyPrefix: 'RM',
        value: overview?.formattedAmount ?? '-',
      ),
      _StatItem(
        iconAsset: SettlementAssets.stat2,
        label: 'Points',
        value: overview?.formattedPoints ?? '-',
      ),
      _StatItem(
        iconAsset: SettlementAssets.stat3,
        label: 'Redeemed',
        value: overview?.formattedRedeemed ?? '-',
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
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: brandBlue.withValues(alpha: 0.12),
                ),
              Expanded(
                child: _StatColumn(item: stats[i], brandBlue: brandBlue),
              ),
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
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 10,
              height: 1.2,
              color: SettlementColors.label,
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

  static const _valueFontSize = 13.0;
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
