import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 物业 SN 二维码弹窗。
class PropertyQrcodeDialog extends StatelessWidget {
  const PropertyQrcodeDialog({
    super.key,
    required this.sn,
    required this.propertyName,
  });

  final String sn;
  final String propertyName;

  static const horizontalInset = 37.0;

  static Future<void> show({
    required String sn,
    required String propertyName,
  }) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: true,
      builder: (_) => PropertyQrcodeDialog(
        sn: sn,
        propertyName: propertyName,
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
                    propertyName,
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
                    sn,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
                      data: sn,
                      size: 200,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Send this QR code to your tenant. They can scan it using the NEAST app to link this property.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: brandBlue.withValues(alpha: 0.6),
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
