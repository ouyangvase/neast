import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/router/auth_navigation.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/auth/provider/personal_profile_provider.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/auth/widgets/login_header.dart';
import 'package:neast/features/auth/widgets/profile_form_card.dart';
import 'package:neast/features/auth/widgets/profile_id_document_section.dart';

/// 注册 / 登录后填写个人资料页。
class FullDataScreen extends ConsumerStatefulWidget {
  const FullDataScreen({super.key});

  @override
  ConsumerState<FullDataScreen> createState() => _FullDataScreenState();
}

class _FullDataScreenState extends ConsumerState<FullDataScreen> {
  static const _pageBackground = Color(0xFFEEF4F9);

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _invitationCodeController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(personalProfileProvider);
    _firstNameController = TextEditingController(text: profile.firstName);
    _lastNameController = TextEditingController(text: profile.lastName);
    _emailController = TextEditingController(text: profile.email);
    _addressController = TextEditingController(text: profile.address);
    _invitationCodeController =
        TextEditingController(text: profile.invitationCode);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _invitationCodeController.dispose();
    super.dispose();
  }

  Widget _buildCardField({
    required Color brandBlue,
    required Color inputColor,
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return ProfileFormCard(
      child: TextField(
        controller: controller,
        autocorrect: false,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: inputColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: brandBlue.withValues(alpha: 0.45),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String? _formatValidUntil(DateTime? date) {
    if (date == null) {
      return null;
    }
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _idTypeValue(IdDocumentType type) {
    return type == IdDocumentType.idCard ? 'id_card' : 'passport';
  }

  bool _isValidEmail(String value) {
    if (value.isEmpty) return true;
    return RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(value);
  }

  bool _validateProfile(PersonalProfileState profile) {
    if (profile.firstName.trim().isEmpty) {
      ToastUtil.show('Please enter your first name');
      return false;
    }

    if (profile.lastName.trim().isEmpty) {
      ToastUtil.show('Please enter your last name');
      return false;
    }

    if (!_isValidEmail(profile.email.trim())) {
      ToastUtil.show('Please enter a valid email address');
      return false;
    }

    if (profile.idNumber.trim().isEmpty) {
      ToastUtil.show('Please enter your ID number');
      return false;
    }

    if (profile.showValidUntil && profile.validUntil == null) {
      ToastUtil.show('Please select the valid until date');
      return false;
    }

    return true;
  }

  Future<void> _onSave() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final profile = ref.read(personalProfileProvider);
    if (!_validateProfile(profile)) {
      return;
    }

    await EasyLoading.show();
    try {
      final saved = await ref.runGuarded(() async {
        await ref.read(authProvider.notifier).completeProfile(
              firstName: profile.firstName.trim(),
              lastName: profile.lastName.trim(),
              idType: _idTypeValue(profile.idDocumentType),
              idNumber: profile.idNumber.trim(),
              idValidUntil: profile.showValidUntil
                  ? _formatValidUntil(profile.validUntil)
                  : null,
              address: profile.address.trim(),
              invitationCode: profile.invitationCode.trim(),
              email: profile.email.trim(),
            );
        return true;
      });
      if (saved != true || !mounted) {
        return;
      }

      await ref.read(userProfileProvider.notifier).refresh();

      ref.read(authProvider.notifier).markAuthenticated();
      if (mounted) {
        navigateAfterAuth(context, ref);
      }
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final inputColor = context.appColors.blackText;
    final notifier = ref.read(personalProfileProvider.notifier);

    return Scaffold(
      backgroundColor: _pageBackground,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(title: 'Personal Profile'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCardField(
                      brandBlue: brandBlue,
                      inputColor: inputColor,
                      controller: _firstNameController,
                      label: 'First name',
                      onChanged: notifier.setFirstName,
                    ),
                    const SizedBox(height: 12),
                    _buildCardField(
                      brandBlue: brandBlue,
                      inputColor: inputColor,
                      controller: _lastNameController,
                      label: 'Last name',
                      onChanged: notifier.setLastName,
                    ),
                    const SizedBox(height: 12),
                    _buildCardField(
                      brandBlue: brandBlue,
                      inputColor: inputColor,
                      controller: _emailController,
                      label: 'Email (optional)',
                      onChanged: notifier.setEmail,
                    ),
                    const SizedBox(height: 12),
                    const ProfileIdDocumentSection(),
                    const SizedBox(height: 12),
                    _buildCardField(
                      brandBlue: brandBlue,
                      inputColor: inputColor,
                      controller: _addressController,
                      label: 'Current residential address',
                      onChanged: notifier.setAddress,
                    ),
                    const SizedBox(height: 12),
                    _buildCardField(
                      brandBlue: brandBlue,
                      inputColor: inputColor,
                      controller: _invitationCodeController,
                      label: 'invitation code',
                      onChanged: notifier.setInvitationCode,
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
          onTap: _onSave,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: brandBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
