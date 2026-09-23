import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/account/models/personal_data_field.dart';
import 'package:neast/features/account/models/user_profile_model.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/account/services/user_service.dart';
import 'package:neast/features/auth/widgets/profile_date_picker_sheet.dart';
import 'package:neast/features/rich_text/widgets/rich_text_header.dart';

/// 个人资料单项编辑页。
class PersonalDataEditScreen extends ConsumerStatefulWidget {
  const PersonalDataEditScreen({
    super.key,
    required this.field,
  });

  final PersonalDataField field;

  @override
  ConsumerState<PersonalDataEditScreen> createState() =>
      _PersonalDataEditScreenState();
}

class _PersonalDataEditScreenState extends ConsumerState<PersonalDataEditScreen> {
  late final TextEditingController _textController;
  DateTime? _validUntil;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFromProfile());
  }

  void _initFromProfile() {
    final profile = ref.read(userProfileProvider).value;
    if (profile == null) {
      return;
    }

    switch (widget.field) {
      case PersonalDataField.firstName:
        _textController.text = profile.firstName;
      case PersonalDataField.lastName:
        _textController.text = profile.lastName;
      case PersonalDataField.email:
        _textController.text = profile.email;
      case PersonalDataField.address:
        _textController.text = profile.address;
      case PersonalDataField.validUntil:
        if (profile.idValidUntil != null && profile.idValidUntil!.isNotEmpty) {
          _validUntil = DateTime.tryParse(profile.idValidUntil!);
        }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String? _formatValidUntil(DateTime? date) {
    if (date == null) {
      return null;
    }
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  bool _isValidEmail(String value) {
    if (value.isEmpty) {
      return true;
    }
    return RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(value);
  }

  bool _validate() {
    switch (widget.field) {
      case PersonalDataField.firstName:
        if (_textController.text.trim().isEmpty) {
          ToastUtil.show('Please enter your first name');
          return false;
        }
        return true;
      case PersonalDataField.lastName:
        if (_textController.text.trim().isEmpty) {
          ToastUtil.show('Please enter your last name');
          return false;
        }
        return true;
      case PersonalDataField.email:
        if (!_isValidEmail(_textController.text.trim())) {
          ToastUtil.show('Please enter a valid email address');
          return false;
        }
        return true;
      case PersonalDataField.validUntil:
        if (_validUntil == null) {
          ToastUtil.show('Please select the valid until date');
          return false;
        }
        return true;
      case PersonalDataField.address:
        return true;
    }
  }

  UserProfileModel _mergeProfile(UserProfileModel profile) {
    switch (widget.field) {
      case PersonalDataField.firstName:
        return profile.copyWith(firstName: _textController.text.trim());
      case PersonalDataField.lastName:
        return profile.copyWith(lastName: _textController.text.trim());
      case PersonalDataField.email:
        return profile.copyWith(email: _textController.text.trim());
      case PersonalDataField.validUntil:
        return profile.copyWith(
          idValidUntil: _formatValidUntil(_validUntil),
        );
      case PersonalDataField.address:
        return profile.copyWith(address: _textController.text.trim());
    }
  }

  Future<void> _onSave() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final profile = ref.read(userProfileProvider).value;
    if (profile == null) {
      ToastUtil.show('Profile not loaded');
      return;
    }

    if (!_validate()) {
      return;
    }

    final updated = _mergeProfile(profile);
    final idValidUntil = updated.isIdCard
        ? null
        : normalizeProfileApiDate(updated.idValidUntil);

    await EasyLoading.show();
    try {
      final saved = await ref.runGuarded(() async {
        await ref.read(userServiceProvider).updateProfile(
              firstName: updated.firstName,
              lastName: updated.lastName,
              idValidUntil: idValidUntil,
              address: updated.address,
              email: updated.email,
            );
        await ref.read(userProfileProvider.notifier).refresh();
        return true;
      });
      if (saved == true && mounted) {
        context.pop();
      }
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _pickValidUntil() async {
    final now = DateTime.now();
    final picked = await showProfileDatePicker(
      context: context,
      initialDate: _validUntil ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 30),
    );
    if (picked != null) {
      setState(() => _validUntil = picked);
    }
  }

  Widget _buildTextEditor(Color brandBlue, Color inputColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        autofocus: true,
        autocorrect: false,
        keyboardType: widget.field == PersonalDataField.email
            ? TextInputType.emailAddress
            : TextInputType.text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: inputColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.field.title,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: brandBlue.withValues(alpha: 0.45),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildValidUntilEditor(Color brandBlue, Color inputColor) {
    final placeholderColor = brandBlue.withValues(alpha: 0.45);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
        onTap: _pickValidUntil,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                'Valid until',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
              const Spacer(),
              Text(
                _validUntil != null
                    ? formatProfileDisplayDate(_validUntil!)
                    : 'Please select',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _validUntil != null ? inputColor : placeholderColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: _validUntil != null ? brandBlue : placeholderColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final inputColor = context.appColors.blackText;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichTextHeader(title: widget.field.title),
          Expanded(
            child: SingleChildScrollView(
              child: switch (widget.field) {
                PersonalDataField.validUntil =>
                  _buildValidUntilEditor(brandBlue, inputColor),
                _ => _buildTextEditor(brandBlue, inputColor),
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
