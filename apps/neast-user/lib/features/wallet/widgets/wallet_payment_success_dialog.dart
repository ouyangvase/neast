import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/wallet/data/wallet_config.dart';

/// 付款成功弹窗。
class WalletPaymentSuccessDialog extends StatelessWidget {
  const WalletPaymentSuccessDialog({super.key});

  static const horizontalInset = 37.0;

  static Future<void> show() {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => const WalletPaymentSuccessDialog(),
    );
  }

  void _dismiss() => SmartDialog.dismiss();

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final dialogWidth =
        MediaQuery.sizeOf(context).width - horizontalInset * 2;

    return Center(
      child: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIllustration(),
                  const SizedBox(height: 24),
                  Text(
                    'Payment Successful',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: brandBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _dismiss,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Image.asset(
      WalletAssets.paymentSuccess,
      width: 180,
      height: 140,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _buildIllustrationPlaceholder(),
    );
  }

  /// 插图占位，后续替换为 [WalletAssets.paymentSuccess] 图片。
  Widget _buildIllustrationPlaceholder() {
    return SizedBox(
      width: 180,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF3EBF7A),
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 40,
              color: Color(0xFFE6A23C),
            ),
          ),
          Positioned(
            right: 18,
            child: Container(
              width: 52,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF0851AA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF3EBF7A),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
