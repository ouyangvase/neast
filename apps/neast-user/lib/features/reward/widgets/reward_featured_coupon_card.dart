import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';

/// Reward 页 Featured 优惠券大图卡片。
class RewardFeaturedCouponCard extends StatelessWidget {
  const RewardFeaturedCouponCard({
    super.key,
    required this.item,
    this.onTap,
  });

  static const cardWidth = 190.0;
  static const cardHeight = 110.0;

  final CouponListItemModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryLabel = item.categoryName.isNotEmpty
        ? item.categoryName
        : item.merchantNames.firstOrNull ?? item.name;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildBackground(),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 400)],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.voucherAmountLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 400)],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.requiredPointsLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 400)],
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (item.image.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: item.image,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return ColoredBox(
      color: const Color(0xFF0851AA),
      child: Center(
        child: Icon(
          Icons.local_offer_outlined,
          size: 40,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
