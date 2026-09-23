import 'package:flutter/material.dart';
import 'package:neast/features/reward/data/reward_tier_constants.dart';
import 'package:neast/features/reward/models/reward_dashboard_model.dart';

/// 奖励等级页 Tier Progress 列表。
class RewardTierProgressList extends StatelessWidget {
  const RewardTierProgressList({
    super.key,
    required this.tiers,
    required this.currentTierId,
  });

  final List<RewardTierItemModel> tiers;
  final int currentTierId;

  static const _lineColor = Color(0xFF111827);
  static const _iconSize = 47.0;
  static const _lineWidth = 1.0;
  static const _itemSpacing = 6.0;
  static const _itemPaddingLeft = 10.0;
  static const _itemPaddingTop = 15.0;
  static const _itemPaddingRight = 18.0;
  static const _itemPaddingBottom = 16.0;
  static const _itemPadding = EdgeInsets.fromLTRB(
    _itemPaddingLeft,
    _itemPaddingTop,
    _itemPaddingRight,
    _itemPaddingBottom,
  );
  static const _iconNameGap = 12.0;
  static const _itemHeight =
      _itemPaddingTop + _iconSize + _itemPaddingBottom;

  static double get _lineLeft =>
      _itemPaddingLeft + _iconSize / 2 - _lineWidth / 2;

  static double get _lineEdgeInset => _itemHeight / 2;

  static double _rowHeight(int index, int total) =>
      _itemHeight + (index == total - 1 ? 0 : _itemSpacing);

  @override
  Widget build(BuildContext context) {
    final displayTiers = [...tiers]..sort((a, b) => b.id.compareTo(a.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tier Progress',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 700)],
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            Column(
              children: [
                for (var i = 0; i < displayTiers.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i == displayTiers.length - 1 ? 0 : _itemSpacing,
                    ),
                    child: _TierProgressBackground(
                      tier: displayTiers[i],
                      isActive: displayTiers[i].id == currentTierId,
                    ),
                  ),
              ],
            ),
            Positioned(
              left: _lineLeft,
              top: _lineEdgeInset,
              bottom: _lineEdgeInset,
              child: Container(
                width: _lineWidth,
                color: _lineColor,
              ),
            ),
            Column(
              children: [
                for (var i = 0; i < displayTiers.length; i++)
                  SizedBox(
                    height: _rowHeight(i, displayTiers.length),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: _itemPaddingLeft, bottom: 7),
                        child: Image.asset(
                          RewardTierConstants.iconAssetForTierId(displayTiers[i].id),
                          width: _iconSize,
                          height: _iconSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TierProgressBackground extends StatelessWidget {
  const _TierProgressBackground({
    required this.tier,
    required this.isActive,
  });

  final RewardTierItemModel tier;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? RewardTierConstants.activeRowBackground
        : RewardTierConstants.tierRowBackground;

    return Container(
      height: RewardTierProgressList._itemHeight,
      padding: RewardTierProgressList._itemPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: RewardTierProgressList._iconSize,
            height: RewardTierProgressList._iconSize,
          ),
          const SizedBox(width: RewardTierProgressList._iconNameGap),
          Expanded(
            child: Text(
              tier.name,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'HG',
                fontVariations: [
                  FontVariation('wght', 700),
                ],
                color: Colors.black,
              ),
            ),
          ),
          Text(
            tier.pointsRangeLabel,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              fontVariations: const [FontVariation('wght', 500)],
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
