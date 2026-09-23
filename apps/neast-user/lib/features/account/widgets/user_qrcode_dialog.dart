import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 用户身份二维码弹窗。
class UserQrcodeDialog extends StatelessWidget {
  const UserQrcodeDialog({
    super.key,
    required this.qrCode,
    required this.displayName,
  });

  final String qrCode;
  final String displayName;

  static const horizontalInset = 37.0;

  static Future<void> show({
    required String qrCode,
    required String displayName,
  }) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: true,
      builder: (_) => UserQrcodeDialog(
        qrCode: qrCode,
        displayName: displayName,
      ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Show this QR code to the merchant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: brandBlue.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: brandBlue.withValues(alpha: 0.08),
                      ),
                    ),
                    child: QrImageView(
                      data: qrCode,
                      size: 200,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
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
}
