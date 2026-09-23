import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// SmartDialog is the service class; FlutterSmartDialog is the builder widget

class AgreementDialog extends StatelessWidget {
  final VoidCallback onAgree;
  final VoidCallback? onUserAgreement;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onCarrierAgreement;

  const AgreementDialog({
    super.key,
    required this.onAgree,
    this.onUserAgreement,
    this.onPrivacyPolicy,
    this.onCarrierAgreement,
  });

  static Future<void> show({
    required VoidCallback onAgree,
    VoidCallback? onUserAgreement,
    VoidCallback? onPrivacyPolicy,
    VoidCallback? onCarrierAgreement,
  }) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => AgreementDialog(
        onAgree: onAgree,
        onUserAgreement: onUserAgreement,
        onPrivacyPolicy: onPrivacyPolicy,
        onCarrierAgreement: onCarrierAgreement,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 28),

            // 标题
            const Text(
              '用户协议及隐私政策',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),

            // 协议内容
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                    height: 1.8,
                  ),
                  children: [
                    const TextSpan(text: '已阅读并同意 '),
                    TextSpan(
                      text: '用户协议',
                      style: const TextStyle(color: Color(0xFF1ADB8B)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onUserAgreement,
                    ),
                    const TextSpan(text: ' 和 '),
                    TextSpan(
                      text: '隐私协议',
                      style: const TextStyle(color: Color(0xFF1ADB8B)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onPrivacyPolicy,
                    ),
                    const TextSpan(text: '\n以及 '),
                    TextSpan(
                      text: '运营商服务协议',
                      style: const TextStyle(color: Color(0xFF1ADB8B)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onCarrierAgreement,
                    ),
                    const TextSpan(text: '，运营商将对你\n提供的手机号进行验证'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 同意并登录按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                    onAgree();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ADB8B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '同意并登录',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 23),

            // 不同意
            GestureDetector(
              onTap: () => SmartDialog.dismiss(),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Text(
                  '不同意',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
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
