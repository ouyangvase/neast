import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/widgets/coupon_action_button.dart';

/// 优惠券兑换列表卡片。
class CouponRewardCard extends StatelessWidget {
  const CouponRewardCard({
    super.key,
    required this.item,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  final CouponListItemModel item;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.pointsLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: brandBlue.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.expiringText,
                    style: TextStyle(
                      fontSize: 11,
                      color: brandBlue.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CouponActionButton(
              status: item.actionStatus,
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
