import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 商户详情信息卡片（商家详情 / 商家二维码等页面共用）。
class MerchantInfoCard extends StatelessWidget {
  const MerchantInfoCard({
    super.key,
    required this.merchantName,
    required this.distance,
    required this.address,
    this.imageUrl = '',
    this.fallbackIcon = Icons.storefront_outlined,
    this.fallbackIconColor = const Color(0xFF0851AA),
  });

  final String merchantName;
  final String distance;
  final String address;
  final String imageUrl;
  final IconData fallbackIcon;
  final Color fallbackIconColor;

  static const _logoSize = 52.0;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

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
              _buildLogo(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchantName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                    if (distance.isNotEmpty) ...[
                      const SizedBox(height: 8),
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
            ],
          ),
          if (address.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              address,
              style: TextStyle(
                fontSize: 12,
                color: brandBlue.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: _logoSize,
        height: _logoSize,
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => _logoPlaceholder(),
                errorWidget: (_, __, ___) => _logoPlaceholder(),
              )
            : _logoPlaceholder(),
      ),
    );
  }

  Widget _logoPlaceholder() {
    return ColoredBox(
      color: fallbackIconColor,
      child: Center(
        child: Icon(
          fallbackIcon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
