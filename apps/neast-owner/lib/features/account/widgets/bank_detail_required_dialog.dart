import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// 创建物业前需先填写 Bank detail 的引导弹窗。
class BankDetailRequiredDialog extends StatelessWidget {
  const BankDetailRequiredDialog({
    super.key,
    required this.onGoToBankDetail,
  });

  final VoidCallback onGoToBankDetail;

  static const horizontalInset = 37.0;

  static Future<void> show({required VoidCallback onGoToBankDetail}) {
    return SmartDialog.show<void>(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => BankDetailRequiredDialog(
        onGoToBankDetail: onGoToBankDetail,
      ),
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
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: brandBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_outlined,
                      size: 28,
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bank detail required',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 600)],
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please add your bank details before creating a property.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 400)],
                      color: brandBlue.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        _dismiss();
                        onGoToBankDetail();
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
                        'Go to Bank detail',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 500)],
                        ),
                      ),
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
