import 'package:flutter/material.dart';
import 'package:neast/features/common/widgets/merchant_detail_hero.dart';

/// 商家详情页骨架屏。
class MerchantScreenSkeleton extends StatelessWidget {
  const MerchantScreenSkeleton({super.key});

  static const _bgColor = Color(0xFFF6F9F6);
  static const _blockColor = Color(0xFFE8ECF0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const MerchantDetailHero(),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -50,
                  child: _InfoCardSkeleton(),
                ),
              ],
            ),
            const SizedBox(height: 72),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _Block(height: 48, borderRadius: 12),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _Block(height: 48, borderRadius: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Block(width: 120, height: 18, borderRadius: 6),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Block(height: 120, borderRadius: 14),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Block(width: 140, height: 18, borderRadius: 6),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: _Block(height: 72, borderRadius: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Block(width: 52, height: 52, borderRadius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Block(width: double.infinity, height: 18, borderRadius: 6),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const _Block(width: 60, height: 14, borderRadius: 4),
                        const SizedBox(width: 10),
                        const _Block(width: 56, height: 20, borderRadius: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _Block(width: 160, height: 14, borderRadius: 4),
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
        color: MerchantScreenSkeleton._blockColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
