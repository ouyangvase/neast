import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/auth_navigation.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/auth/widgets/login_header.dart';
import 'package:neast/features/auth/widgets/verify_resend_sheet.dart';
import 'package:pinput/pinput.dart';

/// 验证码确认页。
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({
    super.key,
    required this.contact,
  });

  final String contact;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  static const _pageBackground = Color(0xFFEEF4F9);

  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _resendCode() async {
    await EasyLoading.show();
    try {
      final sent = await ref.runGuarded(() async {
        await ref.read(authProvider.notifier).sendCode(
              account: widget.contact,
            );
        return true;
      });
      if (sent == true) {
        ToastUtil.show('Verification code sent');
      }
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _submit(String code) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await EasyLoading.show();
    try {
      final result = await ref.runGuarded(() async {
        return ref.read(authProvider.notifier).login(
              account: widget.contact,
              code: code,
            );
      });
      if (result == null || !mounted) return;

      if (!result.profileCompleted) {
        context.go(AppRoutes.fullData);
        return;
      }

      if (!mounted) return;
      navigateAfterAuth(context, ref);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _showResendSheet() {
    _dismissKeyboard();
    VerifyResendSheet.show(
      context,
      onResend: _resendCode,
    );
  }

  PinTheme _pinTheme(Color brandBlue, {bool focused = false}) {
    return PinTheme(
      width: 48,
      height: 52,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: focused ? brandBlue : const Color(0xFFD0D5DD),
          width: focused ? 1.5 : 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final defaultPinTheme = _pinTheme(brandBlue);
    final focusedPinTheme = _pinTheme(brandBlue, focused: true);

    return Scaffold(
      backgroundColor: _pageBackground,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(title: 'Confirm your number'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter the one-time passcode we sent to',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: brandBlue,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: _pinController,
                        focusNode: _pinFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: defaultPinTheme,
                        followingPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 10),
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: _submit,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: _showResendSheet,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        'Didn\'t receive a code?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: brandBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
