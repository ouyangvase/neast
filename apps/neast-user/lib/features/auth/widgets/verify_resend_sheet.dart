import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 未收到验证码时的底部弹窗。
class VerifyResendSheet extends StatelessWidget {
  const VerifyResendSheet({
    super.key,
    required this.onResend,
  });

  final VoidCallback onResend;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onResend,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => VerifyResendSheet(onResend: onResend),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Didn\'t receive a code?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: brandBlue,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onResend();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: brandBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Resend code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
