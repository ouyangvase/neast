import 'package:flutter/material.dart';
import 'package:neast/features/home/widgets/deal_card.dart';

/// 首页商家相关区块骨架屏。
class HomeMerchantSectionSkeleton {
  HomeMerchantSectionSkeleton._();

  static const blockColor = Color(0xFFE8ECF0);
  static const mapBlockColor = Color(0x33FFFFFF);
}

/// 横向 Deal 卡片列表骨架（Featured Deals / Merchant Reward）。
class HomeDealCardsSkeleton extends StatelessWidget {
  const HomeDealCardsSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DealCard.listItemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const HomeDealCardSkeleton(),
      ),
    );
  }
}

class HomeDealCardSkeleton extends StatelessWidget {
  const HomeDealCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DealCard.cardWidth,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Block(
            width: DealCard.cardWidth,
            height: DealCard.cardHeight,
            borderRadius: DealCard.imageRadius,
          ),
          SizedBox(height: 10),
          _Block(width: 96, height: 13, borderRadius: 4),
          SizedBox(height: 6),
          _Block(width: 56, height: 11, borderRadius: 4),
        ],
      ),
    );
  }
}

/// Nearby Merchants 纵向列表骨架。
class HomeSuggestedMerchantsSkeleton extends StatelessWidget {
  const HomeSuggestedMerchantsSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < itemCount; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          const HomeSuggestedMerchantTileSkeleton(),
        ],
      ],
    );
  }
}

class HomeSuggestedMerchantTileSkeleton extends StatelessWidget {
  const HomeSuggestedMerchantTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Row(
        children: [
          _Block(width: 44, height: 44, borderRadius: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Block(width: double.infinity, height: 14, borderRadius: 4),
                SizedBox(height: 8),
                _Block(width: 72, height: 12, borderRadius: 4),
              ],
            ),
          ),
          SizedBox(width: 8),
          _Block(width: 20, height: 20, borderRadius: 4),
        ],
      ),
    );
  }
}

/// Nearby Merchants 地图卡片骨架。
class HomeNearbyMerchantsMapSkeleton extends StatelessWidget {
  const HomeNearbyMerchantsMapSkeleton({super.key});

  static const _cardHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D2567),
            Color(0xFF1A3A7A),
          ],
        ),
      ),
      child: Stack(
        children: [
          const _MapGridLines(),
          const Positioned(left: 36, top: 42, child: _MapPinSkeleton()),
          const Positioned(right: 48, top: 56, child: _MapPinSkeleton()),
          const Positioned(left: 72, bottom: 38, child: _MapPinSkeleton()),
          const Positioned(right: 64, bottom: 52, child: _MapPinSkeleton()),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: HomeMerchantSectionSkeleton.mapBlockColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPinSkeleton extends StatelessWidget {
  const _MapPinSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MapBlock(width: 48, height: 18, borderRadius: 6),
        SizedBox(height: 4),
        _MapBlock(width: 36, height: 36, borderRadius: 18),
      ],
    );
  }
}

class _MapGridLines extends StatelessWidget {
  const _MapGridLines();

  @override
  Widget build(BuildContext context) {
    final line = Colors.white.withValues(alpha: 0.06);
    return Stack(
      children: [
        for (var i = 0; i < 6; i++)
          Positioned(
            left: 0,
            right: 0,
            top: i * 40.0,
            child: Divider(height: 1, thickness: 1, color: line),
          ),
        for (var i = 0; i < 6; i++)
          Positioned(
            top: 0,
            bottom: 0,
            left: i * 72.0,
            child: VerticalDivider(width: 1, thickness: 1, color: line),
          ),
      ],
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HomeMerchantSectionSkeleton.blockColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _MapBlock extends StatelessWidget {
  const _MapBlock({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HomeMerchantSectionSkeleton.mapBlockColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
