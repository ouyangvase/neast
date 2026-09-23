import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';

/// 优惠券兑换确认弹窗。
class CouponRedeemConfirmDialog extends StatelessWidget {
  const CouponRedeemConfirmDialog({
    super.key,
    required this.item,
  });

  final CouponListItemModel item;

  static const horizontalInset = 37.0;

  static Future<bool> show(CouponListItemModel item) async {
    final result = await SmartDialog.show<bool>(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: true,
      builder: (_) => CouponRedeemConfirmDialog(item: item),
    );
    return result == true;
  }

  void _dismiss(bool confirmed) => SmartDialog.dismiss(result: confirmed);

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final dialogWidth =
        MediaQuery.sizeOf(context).width - horizontalInset * 2;
    final pointsLabel =
        NumberFormat('#,###').format(item.requiredPoints);

    return Center(
      child: SizedBox(
        width: dialogWidth,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Redeem ${item.name}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$pointsLabel pts will be used',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: brandBlue.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _dismiss(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: brandBlue,
                        side: BorderSide(
                          color: brandBlue.withValues(alpha: 0.25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _dismiss(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
