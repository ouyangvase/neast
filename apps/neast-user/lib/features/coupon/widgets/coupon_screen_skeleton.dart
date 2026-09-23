import 'package:flutter/material.dart';
import 'package:neast/features/common/widgets/neast_brand_header.dart';

/// 优惠券页骨架屏。
class CouponScreenSkeleton extends StatelessWidget {
  const CouponScreenSkeleton({
    super.key,
    this.showCategoryTabs = true,
    this.headerTitle,
  });

  final bool showCategoryTabs;
  final Widget? headerTitle;

  static const _blockColor = Color(0xFFE8ECF0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NeastBrandHeader(
          title: headerTitle ?? NeastBrandHeader.neastRichTitle('rewards'),
        ),
        const SizedBox(height: 20),
        if (showCategoryTabs) ...[
          const CouponCategoryTabsSkeleton(),
          const SizedBox(height: 12),
        ],
        const Expanded(child: CouponListSkeleton()),
      ],
    );
  }
}

/// 分类 Tab 骨架屏。
class CouponCategoryTabsSkeleton extends StatelessWidget {
  const CouponCategoryTabsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final width = index == 0 ? 48.0 : 72.0 + (index * 8.0);
          return _Block(width: width, height: 36, borderRadius: 18);
        },
      ),
    );
  }
}

/// 优惠券列表骨架屏。
class CouponListSkeleton extends StatelessWidget {
  const CouponListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const CouponRewardCardSkeleton(),
    );
  }
}

/// 单张优惠券卡片骨架屏。
class CouponRewardCardSkeleton extends StatelessWidget {
  const CouponRewardCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Block(width: 50, height: 50, borderRadius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Block(width: double.infinity, height: 14, borderRadius: 4),
                SizedBox(height: 8),
                _Block(width: 72, height: 12, borderRadius: 4),
                SizedBox(height: 8),
                _Block(width: 110, height: 11, borderRadius: 4),
              ],
            ),
          ),
          SizedBox(width: 8),
          _Block(width: 88, height: 34, borderRadius: 8),
        ],
      ),
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
        color: CouponScreenSkeleton._blockColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
