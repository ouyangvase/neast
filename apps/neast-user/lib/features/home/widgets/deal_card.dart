import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/home/widgets/home_address_tag.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';

/// 首页横向优惠卡片，展示商户图片、位置及距离。
class DealCard extends StatelessWidget {
  const DealCard({super.key, required this.merchant, this.onTap});

  static const cardWidth = 110.0;
  static const cardHeight = 80.0;
  static const listItemHeight = cardHeight + 52.0;
  static const imageRadius = 10.0;

  final MerchantModel merchant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final mutedBlue = brandBlue.withValues(alpha: 0.5);
    final distanceLabel = merchant.distanceLabel;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(imageRadius),
                  child: SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildImage(),
                  ),
                ),
                if (merchant.address.isNotEmpty)
                  Positioned(
                    top: 7,
                    left: 7,
                    child: HomeAddressTag(
                      address: merchant.address,
                      maxWidth: cardWidth * 0.9,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                merchant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ),
            if (distanceLabel.isNotEmpty) ...[
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 11,
                      color: mutedBlue,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        distanceLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: mutedBlue,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (merchant.image.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: merchant.image,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholderImage(),
        errorWidget: (_, __, ___) => _placeholderImage(),
      );
    }

    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return ColoredBox(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.storefront_outlined, color: Colors.grey, size: 32),
      ),
    );
  }
}
