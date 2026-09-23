import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/properties/properties_assets.dart';

/// 添加物业提交成功弹窗。
class AddPropertySuccessDialog extends StatelessWidget {
  const AddPropertySuccessDialog({super.key});

  static const horizontalInset = 37.0;

  /// 展示弹窗，关闭后 Future 完成。
  static Future<void> show() {
    return SmartDialog.show<void>(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => const AddPropertySuccessDialog(),
    );
  }

  void _dismiss() => SmartDialog.dismiss<void>();

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
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    PropertiesAssets.success,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Submission successful',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 500)],
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
}
