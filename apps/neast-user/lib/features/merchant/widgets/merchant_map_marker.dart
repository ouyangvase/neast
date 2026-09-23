import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';

/// 地图商家标点：上方内容卡 + 下方 Location 图标，两块相邻无包含关系。
class MerchantMapMarker extends StatelessWidget {
  const MerchantMapMarker({
    super.key,
    required this.merchant,
    this.onTap,
  });

  final MerchantModel merchant;
  final VoidCallback? onTap;

  static const double markerWidth = 132;
  static const double markerHeight = 92;

  static Marker buildMarker({
    required MerchantModel merchant,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: LatLng(merchant.latitude!, merchant.longitude!),
      width: markerWidth,
      height: markerHeight,
      // topCenter：marker 整体位于地理点上方，锚点为框底边中心（图钉尖），
      // 使图钉尖始终扎在地理点上，缩放时不漂移。
      alignment: Alignment.topCenter,
      child: MerchantMapMarker(
        merchant: merchant,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // 图钉压到框底部，使图钉底边与锚点（框底边中心）重合。
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _InfoCard(merchant: merchant, brandBlue: brandBlue),
          Icon(
            Icons.location_on,
            size: 30,
            color: brandBlue,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.merchant,
    required this.brandBlue,
  });

  final MerchantModel merchant;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MerchantMapMarker.markerWidth,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 34,
              height: 34,
              child: _MerchantImage(imageUrl: merchant.image),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  merchant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                if (merchant.distanceLabel.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    merchant.shortDistanceLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: brandBlue.withValues(alpha: 0.65),
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

class _MerchantImage extends StatelessWidget {
  const _MerchantImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _placeholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => _placeholder(),
      errorWidget: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return ColoredBox(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.storefront_outlined, size: 18, color: Colors.grey),
      ),
    );
  }
}

/// 用户当前位置标点。
class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  static const double markerWidth = 120;
  static const double markerHeight = 88;

  static Marker buildMarker({required LatLng point}) {
    return Marker(
      point: point,
      width: markerWidth,
      height: markerHeight,
      // topCenter：marker 整体位于地理点上方，锚点为框底边中心（定位圆点），
      // 缩放时圆点始终固定在地理点上。
      alignment: Alignment.topCenter,
      child: const UserLocationMarker(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      // 圆点压到框底部，使其与锚点（框底边中心）对齐。
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: brandBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'You are here',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withValues(alpha: 0.15),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withValues(alpha: 0.25),
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
