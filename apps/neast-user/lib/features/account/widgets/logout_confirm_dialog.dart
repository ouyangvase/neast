import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 退出登录确认弹窗（风格与 [DeleteAccountDialog] 一致，无插图）。
class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({
    super.key,
    this.onConfirm,
  });

  final VoidCallback? onConfirm;

  static Future<void> show({VoidCallback? onConfirm}) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => LogoutConfirmDialog(onConfirm: onConfirm),
    );
  }

  void _dismiss() => SmartDialog.dismiss();

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: _dismiss,
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
                            'Cancel',
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
                          onPressed: () {
                            _dismiss();
                            onConfirm?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'OK',
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
    );
  }
}
