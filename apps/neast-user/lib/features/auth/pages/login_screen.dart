import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/auth/provider/login_provider.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/auth/widgets/country_code_picker_sheet.dart';
import 'package:neast/features/auth/widgets/login_header.dart';

/// 登录 / 注册入口页，仅支持手机号。
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _pageBackground = Color(0xFFEEF4F9);

  /// 输入框边框区域高度。
  static const _fieldHeight = 52.0;

  /// 含浮动标签的输入区总高度。
  static const _inputSectionHeight = 72.0;

  static const _hintFontSize = 12.0;

  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    final state = ref.read(loginProvider);
    if (!state.canSubmit) return;

    FocusManager.instance.primaryFocus?.unfocus();
    final contact = state.fullPhoneAccount;

    await EasyLoading.show();
    try {
      final sent = await ref.runGuarded(() async {
        await ref.read(authProvider.notifier).sendCode(
              account: contact,
            );
        return true;
      });
      if (sent != true || !mounted) return;

      context.push(
        '${AppRoutes.verify}?contact=${Uri.encodeComponent(contact)}',
      );
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

  Widget _buildCountryCodeBox(Color brandBlue, String countryCode) {
    const borderRadius = BorderRadius.all(Radius.circular(12));

    return SizedBox(
      height: _fieldHeight,
      child: Material(
        color: Colors.white,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: _showCountryCodeSheet,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: const Color(0xFFD0D5DD)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      countryCode,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: brandBlue,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: brandBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCountryCodeSheet() async {
    _dismissKeyboard();
    final codes = ref.read(countryCodesProvider).maybeWhen(
          data: (list) => list.map((item) => item.code).toList(),
          orElse: () => const <String>[],
        );
    final options = codes.isNotEmpty ? codes : const ['+60', '+65'];

    final selected = await CountryCodePickerSheet.show(
      context,
      codes: options,
      selected: ref.read(loginProvider).countryCode,
    );
    if (selected != null) {
      ref.read(loginProvider.notifier).setCountryCode(selected);
    }
  }

  Widget _buildOutlineField({
    required Color brandBlue,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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

  Widget _buildPhoneInput(Color brandBlue, String countryCode) {
    return SizedBox(
      height: _inputSectionHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildCountryCodeBox(brandBlue, countryCode),
          const SizedBox(width: 12),
          Expanded(
            child: _buildOutlineField(
              brandBlue: brandBlue,
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              label: 'Phone number',
              hint: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: ref.read(loginProvider.notifier).setPhone,
            ),
          ),
        ],
      ),
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final loginState = ref.watch(loginProvider);
    final canSubmit = loginState.canSubmit;
    ref.watch(countryCodesProvider);

    return Scaffold(
      backgroundColor: _pageBackground,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPhoneInput(brandBlue, loginState.countryCode),
                    const SizedBox(height: 16),
                    Text(
                      'Local demo: 123456789  ·  OTP 123456',
                      style: TextStyle(
                        fontSize: 13,
                        color: brandBlue.withValues(alpha: 0.7),
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
          onTap: canSubmit ? _onNext : null,
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
                'Next',
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
