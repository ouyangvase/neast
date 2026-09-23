import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/auth/provider/login_provider.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/auth/widgets/login_header.dart';

/// 登录页：邮箱 + 密码。
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _pageBackground = Color(0xFFEEF4F9);
  static const _inputSectionHeight = 72.0;
  static const _hintFontSize = 12.0;

  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _accountFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final state = ref.read(loginProvider);
    if (!state.canSubmit) return;

    FocusManager.instance.primaryFocus?.unfocus();
    await EasyLoading.show();
    try {
      final ok = await ref.runGuarded(() async {
        return ref.read(authProvider.notifier).login(
              account: state.account.trim(),
              password: state.password,
            );
      });
      if (ok != true || !mounted) return;
      context.go(AppRoutes.main);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  InputDecoration _inputDecoration({
    required Color brandBlue,
    required String label,
    String? hint,
  }) {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    final borderSide = BorderSide(color: brandBlue.withValues(alpha: 0.85));

    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      alignLabelWithHint: true,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: brandBlue,
      ),
      hintStyle: TextStyle(
        fontSize: _hintFontSize,
        color: brandBlue.withValues(alpha: 0.35),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: brandBlue, width: 1.5),
      ),
    );
  }

  Widget _buildOutlineField({
    required Color brandBlue,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autocorrect: false,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: brandBlue,
      ),
      decoration: _inputDecoration(
        brandBlue: brandBlue,
        label: label,
        hint: hint,
      ),
      onChanged: onChanged,
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final canSubmit = ref.watch(loginProvider).canSubmit;

    return Scaffold(
      backgroundColor: _pageBackground,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(title: 'Login in'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: _inputSectionHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildOutlineField(
                          brandBlue: brandBlue,
                          controller: _accountController,
                          focusNode: _accountFocusNode,
                          label: 'Account',
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          onChanged:
                              ref.read(loginProvider.notifier).setAccount,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: _inputSectionHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildOutlineField(
                          brandBlue: brandBlue,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          label: 'Password',
                          hint: 'Enter your password',
                          obscureText: true,
                          onChanged:
                              ref.read(loginProvider.notifier).setPassword,
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
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: GestureDetector(
          onTap: canSubmit ? _onLogin : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: canSubmit ? 1 : 0.45,
            child: Container(
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: brandBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
