import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';

/// 首页建议商户列表单项，展示 logo、名称及距离。
class SuggestedMerchantTile extends StatelessWidget {
  const SuggestedMerchantTile({
    super.key,
    required this.merchant,
    this.onTap,
  });

  final MerchantModel merchant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final mutedBlue = brandBlue.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: _buildAvatar(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                if (merchant.distanceLabel.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: mutedBlue,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        merchant.distanceLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: mutedBlue,
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

  Widget _buildAvatar() {
    if (merchant.image.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: merchant.image,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholderAvatar(),
        errorWidget: (_, __, ___) => _placeholderAvatar(),
      );
    }

    return _placeholderAvatar();
  }

  Widget _placeholderAvatar() {
    return ColoredBox(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.storefront_outlined, color: Colors.grey, size: 22),
      ),
    );
  }
}
