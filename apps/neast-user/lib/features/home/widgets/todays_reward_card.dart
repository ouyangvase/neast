import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/home/providers/home_dashboard_provider.dart';

/// 首页「Today's Reward」卡片。
class TodaysRewardCard extends ConsumerWidget {
  const TodaysRewardCard({super.key});

  static const _fallbackGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF2B1B10),
      Color(0xFF5A3A21),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupon = ref.watch(homeDashboardProvider).value?.todayReward;
    final rewardName = coupon?.name.isNotEmpty == true ? coupon!.name : 'Reward';
    final pointsLabel = coupon?.requiredPointsLabel ?? '-- points';
    final imageUrl = coupon?.image ?? '';

    return Container(
      height: 128,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: imageUrl.isEmpty ? _fallbackGradient : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isNotEmpty) ...[
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const DecoratedBox(
                decoration: BoxDecoration(gradient: _fallbackGradient),
              ),
              errorWidget: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(gradient: _fallbackGradient),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Reward",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 400)],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rewardName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 600)],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pointsLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 500)],
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.coupon),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      'Claim Now',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 600)],
                        color: context.appColors.brandBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
