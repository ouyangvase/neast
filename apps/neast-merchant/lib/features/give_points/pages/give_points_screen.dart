import 'package:flutter/material.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/give_points/widgets/give_points_earn_rule_card.dart';
import 'package:neast/features/give_points/widgets/give_points_header.dart';
import 'package:neast/features/give_points/widgets/give_points_outlet_card.dart';
import 'package:neast/features/give_points/widgets/give_points_receipt_card.dart';
import 'package:neast/features/give_points/widgets/give_points_stats_card.dart';

class GivePointsScreen extends StatelessWidget {
  const GivePointsScreen({super.key});
  static const _headerAspectRatio = 510 / 1125;
  static const _statsCardOverlap = 51.0;
  static const _statsCardHeight = 92.0;

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.sizeOf(context).width * _headerAspectRatio;

    return ColoredBox(
      color: GivePointsColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: headerHeight + _statsCardHeight - _statsCardOverlap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const GivePointsHeader(),
                Positioned(
                  left: 16,
                  right: 16,
                  top: headerHeight - _statsCardOverlap,
                  child: const GivePointsStatsCard(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GivePointsReceiptCard(),
                  SizedBox(height: 14),
                  GivePointsEarnRuleCard(),
                  SizedBox(height: 14),
                  GivePointsOutletCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
