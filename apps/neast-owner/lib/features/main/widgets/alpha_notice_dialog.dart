import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// Alpha 冷启动提示弹窗。
class AlphaNoticeDialog extends StatelessWidget {
  const AlphaNoticeDialog({super.key});

  static Future<void> show() {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => const AlphaNoticeDialog(),
    );
  }

  void _dismiss() => SmartDialog.dismiss();

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Center(
      child: Container(
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
              "Hey , you're early!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: brandBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "NEAST's still in alpha, so expect a few rough edges here and there. Spot something weird? Let us know!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: brandBlue,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _dismiss,
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
          ],
        ),
      ),
    );
  }
}
