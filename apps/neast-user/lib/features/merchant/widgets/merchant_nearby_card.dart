import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/merchant/data/merchant_detail_constants.dart';

/// 商家详情页附近商户卡片。
class MerchantNearbyCard extends StatelessWidget {
  const MerchantNearbyCard({
    super.key,
    required this.name,
    required this.distance,
    this.imageUrl = '',
    this.onTap,
  });

  final String name;
  final String distance;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final iconColor = MerchantDetailConstants.iconColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 44,
                height: 44,
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _logoPlaceholder(iconColor),
                        errorWidget: (_, __, ___) => _logoPlaceholder(iconColor),
                      )
                    : _logoPlaceholder(iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: brandBlue,
                    ),
                  ),
                  if (distance.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: brandBlue.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          distance,
                          style: TextStyle(
                            fontSize: 12,
                            color: brandBlue.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: brandBlue.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoPlaceholder(Color iconColor) {
    return ColoredBox(
      color: iconColor.withValues(alpha: 0.12),
      child: Center(
        child: Icon(
          MerchantDetailConstants.icon,
          size: 22,
          color: iconColor,
        ),
      ),
    );
  }
}
