import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限被永久拒绝时展示说明，仅用户点击才跳转 Settings。
Future<void> showPermissionDeniedDialog(
  BuildContext context, {
  required String title,
  required String message,
  IconData icon = Icons.lock_outline_rounded,
  List<String>? reasons,
  String settingsHint =
      'If you previously denied access, enable the permission in Settings.',
}) async {
  final openSettings = await SmartDialog.show<bool>(
    maskColor: Colors.black.withValues(alpha: 0.5),
    clickMaskDismiss: true,
    builder: (_) => PermissionDeniedDialog(
      title: title,
      message: message,
      icon: icon,
      reasons: reasons,
      settingsHint: settingsHint,
    ),
  );

  if (openSettings == true) {
    await openAppSettings();
  }
}

/// 扫码页 / Confirm Points — 相机权限被永久拒绝。
Future<void> showCameraScanPermissionDeniedDialog(BuildContext context) {
  return showPermissionDeniedDialog(
    context,
    title: 'Camera Access Required',
    icon: Icons.qr_code_scanner_rounded,
    message:
        'NEAST uses your camera to scan customer QR codes and coupon codes.',
    reasons: const [
      'Scan voucher and coupon QR codes at checkout',
      'Identify customers quickly when redeeming offers',
      'Camera is only used for in-app scanning',
    ],
    settingsHint:
        'If you previously denied camera access, enable Camera in Settings to scan QR codes.',
  );
}

/// Scan 页相册选图 — 相册权限被永久拒绝。
Future<void> showPhotoLibraryScanPermissionDeniedDialog(BuildContext context) {
  return showPermissionDeniedDialog(
    context,
    title: 'Photo Library Access Required',
    icon: Icons.photo_library_outlined,
    message:
        'NEAST uses your photo library to read QR codes from saved images.',
    reasons: const [
      'Select a QR code image saved on your device',
      'Redeem vouchers without rescanning in person',
      'Images are used only for QR code detection',
    ],
    settingsHint:
        'If you previously denied photo access, enable Photos in Settings to read QR codes from gallery.',
  );
}

class PermissionDeniedDialog extends StatelessWidget {
  const PermissionDeniedDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.reasons,
    required this.settingsHint,
  });

  final String title;
  final String message;
  final IconData icon;
  final List<String>? reasons;
  final String settingsHint;

  void _dismiss({bool openSettings = false}) {
    SmartDialog.dismiss(result: openSettings);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final blackText = context.appColors.blackText;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: brandBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 34,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: blackText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: blackText.withValues(alpha: 0.72),
                  ),
                ),
                if (reasons != null && reasons!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ...reasons!.map(
                    (reason) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ReasonRow(
                        text: reason,
                        color: brandBlue,
                        textColor: blackText,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  settingsHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: blackText.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => _dismiss(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: brandBlue,
                            side: BorderSide(
                              color: brandBlue.withValues(alpha: 0.2),
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Not Now',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => _dismiss(openSettings: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Open Settings',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _dismiss(),
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
    );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.text,
    required this.color,
    required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: textColor.withValues(alpha: 0.82),
            ),
          ),
        ),
      ],
    );
  }
}
