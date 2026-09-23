import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/utils/notifier_utils.dart';
import 'package:neast_landlords/features/auth/provider/login_provider.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/features/auth/widgets/country_code_picker_sheet.dart';
import 'package:neast_landlords/features/auth/widgets/login_auth_mode_switch.dart';
import 'package:neast_landlords/features/auth/widgets/login_header.dart';

/// 登录 / 注册入口页：Log in 仅手机号，Sign up 需姓名 + 手机号。
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  static const _pageBackground = Color(0xFFEEF4F9);
  static const _fieldHeight = 52.0;
  static const _inputSectionHeight = 72.0;
  static const _hintFontSize = 12.0;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    final mode =
        _tabController.index == 0 ? AuthMode.login : AuthMode.signup;
    if (ref.read(loginProvider).mode != mode) {
      ref.read(loginProvider.notifier).setMode(mode);
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSendCode() async {
    final state = ref.read(loginProvider);
    if (!state.canSubmit) return;

    FocusManager.instance.primaryFocus?.unfocus();
    final phone = state.fullPhoneAccount;
    final mode = state.mode;

    await EasyLoading.show();
    try {
      final sent = await ref.runGuarded(() async {
        await ref.read(authProvider.notifier).sendCode(phone: phone, mode: mode);
        return true;
      });
      if (sent != true || !mounted) return;

      final modeParam = mode.routeValue;
      if (mode == AuthMode.login) {
        context.push(
          '${AppRoutes.verify}?phone=${Uri.encodeComponent(phone)}&mode=$modeParam',
        );
        return;
      }

      final firstName = Uri.encodeComponent(state.firstName.trim());
      final lastName = Uri.encodeComponent(state.lastName.trim());
      context.push(
        '${AppRoutes.verify}?phone=${Uri.encodeComponent(phone)}&mode=$modeParam&firstName=$firstName&lastName=$lastName',
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
              label: 'Phone',
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

  Widget _buildLoginForm(Color brandBlue, String countryCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhoneInput(brandBlue, countryCode),
      ],
    );
  }

  Widget _buildSignupForm(Color brandBlue, String countryCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: _inputSectionHeight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildOutlineField(
              brandBlue: brandBlue,
              controller: _firstNameController,
              focusNode: _firstNameFocusNode,
              label: 'First Name',
              hint: 'Enter your first name',
              onChanged: ref.read(loginProvider.notifier).setFirstName,
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
              controller: _lastNameController,
              focusNode: _lastNameFocusNode,
              label: 'Last Name',
              hint: 'Enter your last name',
              onChanged: ref.read(loginProvider.notifier).setLastName,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildPhoneInput(brandBlue, countryCode),
      ],
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
                    LoginAuthModeSwitch(controller: _tabController),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: _inputSectionHeight * 3 + 32,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildLoginForm(brandBlue, loginState.countryCode),
                          _buildSignupForm(brandBlue, loginState.countryCode),
                        ],
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
          onTap: canSubmit ? _onSendCode : null,
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
