import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/home/widgets/home_address_tag.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';

/// 积分页 Merchant Reward 网格卡片。
class PointsMerchantRewardCard extends StatelessWidget {
  const PointsMerchantRewardCard({
    super.key,
    required this.merchant,
    this.onTap,
  });

  final MerchantModel merchant;
  final VoidCallback? onTap;

  static const _radius = 15.0;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final distanceLabel = merchant.distanceLabel;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: _buildImage(),
                      ),
                      if (merchant.address.isNotEmpty)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: HomeAddressTag(
                            address: merchant.address,
                            maxWidth: constraints.maxWidth * 0.9,
                            textStyle: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            iconSize: 10,
                            horizontalPadding: 6,
                            verticalPadding: 3,
                            borderRadius: 6,
                            backgroundOpacity: 0.55,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            merchant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: brandBlue,
            ),
          ),
          if (distanceLabel.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              distanceLabel,
              style: TextStyle(
                fontSize: 11,
                color: brandBlue.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
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
        child: Icon(Icons.storefront_outlined, color: Colors.grey, size: 40),
      ),
    );
  }
}
