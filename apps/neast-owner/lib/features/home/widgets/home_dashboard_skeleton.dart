import 'package:flutter/material.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

/// 首页内容区骨架屏。
class HomeDashboardSkeleton extends StatelessWidget {
  const HomeDashboardSkeleton({super.key});

  static const _boneColor = Color(0xFFE8EEF4);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NeedActionSkeleton(),
        const SizedBox(height: 26),
        const _SkeletonLine(width: 120, height: 16),
        const SizedBox(height: 12),
        _RentCardSkeleton(),
        const SizedBox(height: 12),
        _RentCardSkeleton(),
        const SizedBox(height: 26),
        const _SkeletonLine(width: 80, height: 16),
        const SizedBox(height: 12),
        _RentCardSkeleton(compact: true),
        const SizedBox(height: 26),
        const _SkeletonLine(width: 160, height: 16),
        const SizedBox(height: 12),
        _AckCardSkeleton(),
        const SizedBox(height: 26),
        const _SkeletonLine(width: 140, height: 16),
        const SizedBox(height: 12),
        _PortfolioSkeleton(),
      ],
    );
  }
}

class _NeedActionSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonLine(width: 110, height: 12),
          const SizedBox(height: 10),
          const _SkeletonLine(width: 140, height: 20),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  if (i > 0)
                    const VerticalDivider(
                      width: 30,
                      thickness: 1,
                      color: Color(0xFFECF4FF),
                    ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonLine(width: 48, height: 12),
                        SizedBox(height: 8),
                        _SkeletonLine(width: 24, height: 14),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RentCardSkeleton extends StatelessWidget {
  const _RentCardSkeleton({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonBox(width: 40, height: 40, radius: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 120, height: 14),
                SizedBox(height: 6),
                _SkeletonLine(width: 160, height: 10),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!compact) ...[
                const _SkeletonBox(width: 56, height: 18, radius: 10),
                const SizedBox(height: 10),
              ],
              const _SkeletonLine(width: 64, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _AckCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      child: Row(
        children: [
          const _SkeletonBox(width: 40, height: 40, radius: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 180, height: 14),
                SizedBox(height: 6),
                _SkeletonLine(width: 100, height: 10),
              ],
            ),
          ),
          const _SkeletonBox(width: 20, height: 20, radius: 4),
        ],
      ),
    );
  }
}

class _PortfolioSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCard(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0)
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: HomeDashboardSkeleton._boneColor,
                ),
              const Expanded(
                child: Column(
                  children: [
                    _SkeletonLine(width: 56, height: 12),
                    SizedBox(height: 8),
                    _SkeletonLine(width: 40, height: 14),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _SkeletonBox(width: width, height: height, radius: 4);
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HomeDashboardSkeleton._boneColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
