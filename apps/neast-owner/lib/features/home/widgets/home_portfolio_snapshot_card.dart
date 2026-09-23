import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

class _PortfolioStat {
  const _PortfolioStat(this.label, this.value);

  final String label;
  final String value;
}

/// 资产概览卡片。
class HomePortfolioSnapshotSection extends StatelessWidget {
  const HomePortfolioSnapshotSection({
    super.key,
    required this.properties,
    required this.tenants,
    required this.rentRoll,
  });

  final int properties;
  final int tenants;
  final String rentRoll;

  List<_PortfolioStat> get _stats => [
        _PortfolioStat('Properties', '$properties'),
        _PortfolioStat('Tenants', '$tenants'),
        _PortfolioStat('Rent Roll', rentRoll),
      ];

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeCard(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < _stats.length; i++) ...[
                  if (i > 0)
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: brandBlue.withValues(alpha: 0.12),
                    ),
                  Expanded(
                    child: _StatColumn(
                      stat: _stats[i],
                      brandBlue: brandBlue,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.stat, required this.brandBlue});

  final _PortfolioStat stat;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          stat.label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 400)],
            color: HomeColors.label,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stat.value,
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
