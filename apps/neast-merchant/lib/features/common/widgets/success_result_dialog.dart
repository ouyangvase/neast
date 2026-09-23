import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 通用成功结果弹窗：插图 + 文案 + 关闭按钮。
class SuccessResultDialog extends StatelessWidget {
  const SuccessResultDialog({
    super.key,
    required this.imageAsset,
    required this.message,
    this.onClose,
  });

  final String imageAsset;
  final String message;
  final VoidCallback? onClose;

  static Future<void> show({
    required String imageAsset,
    required String message,
    VoidCallback? onClose,
  }) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => SuccessResultDialog(
        imageAsset: imageAsset,
        message: message,
        onClose: onClose,
      ),
    );
  }

  void _dismiss() {
    SmartDialog.dismiss();
    onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 36),
            padding: const EdgeInsets.fromLTRB(24, 42, 24, 42),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imageAsset,
                  width: 130,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
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
              width: 29,
              height: 29,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
