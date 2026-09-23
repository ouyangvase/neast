import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';

/// 我的优惠券卡片。
class MyVoucherCard extends StatelessWidget {
  const MyVoucherCard({
    super.key,
    required this.item,
    this.onUseNow,
  });

  final CouponListItemModel item;
  final VoidCallback? onUseNow;

  static const _cardHeight = 112.0;

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;
    final enabled = item.isMyVoucherActionEnabled;

    return Container(
      height: _cardHeight,
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
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildLeftBackground(brandBlueLight),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 600)],
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.myVoucherAmountTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 600)],
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.myVoucherStatusLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 500)],
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.myVoucherDateLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 700)],
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: TextButton(
                      onPressed: enabled ? onUseNow : null,
                      style: TextButton.styleFrom(
                        backgroundColor: enabled
                            ? brandBlueLight
                            : const Color(0xFFE5E7EB),
                        foregroundColor:
                            enabled ? Colors.white : const Color(0xFF9CA3AF),
                        disabledBackgroundColor: const Color(0xFFE5E7EB),
                        disabledForegroundColor: const Color(0xFF9CA3AF),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Use Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftBackground(Color brandBlueLight) {
    if (item.image.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: item.image,
            fit: BoxFit.cover,
            placeholder: (_, __) => ColoredBox(color: brandBlueLight),
            errorWidget: (_, __, ___) => ColoredBox(color: brandBlueLight),
          ),
          ColoredBox(color: Colors.black.withValues(alpha: 0.35)),
        ],
      );
    }

    return ColoredBox(color: brandBlueLight);
  }
}
