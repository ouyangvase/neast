import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 兑换页底部操作区（确认兑换 + 取消）。
class RedeemBottomActions extends StatelessWidget {
  const RedeemBottomActions({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Confirm Redeem',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  foregroundColor: brandBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
