import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/auth/provider/personal_profile_provider.dart';
import 'package:neast/features/auth/widgets/profile_date_picker_sheet.dart';
import 'package:neast/features/auth/widgets/profile_form_card.dart';

/// 证件类型选择与 ID number / Valid until 区块。
class ProfileIdDocumentSection extends ConsumerStatefulWidget {
  const ProfileIdDocumentSection({super.key});

  @override
  ConsumerState<ProfileIdDocumentSection> createState() =>
      _ProfileIdDocumentSectionState();
}

class _ProfileIdDocumentSectionState
    extends ConsumerState<ProfileIdDocumentSection> {
  late final TextEditingController _idNumberController;

  @override
  void initState() {
    super.initState();
    _idNumberController = TextEditingController(
      text: ref.read(personalProfileProvider).idNumber,
    );
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickValidUntil() async {
    final now = DateTime.now();
    final picked = await showProfileDatePicker(
      context: context,
      initialDate: ref.read(personalProfileProvider).validUntil ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 30),
    );
    if (picked != null) {
      ref.read(personalProfileProvider.notifier).setValidUntil(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final inputColor = context.appColors.blackText;
    final placeholderColor = brandBlue.withValues(alpha: 0.45);
    final profile = ref.watch(personalProfileProvider);
    final notifier = ref.read(personalProfileProvider.notifier);

    return ProfileFormCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                _DocumentTypeOption(
                  label: 'ID card',
                  selected: profile.idDocumentType == IdDocumentType.idCard,
                  brandBlue: brandBlue,
                  onTap: () =>
                      notifier.setIdDocumentType(IdDocumentType.idCard),
                ),
                const SizedBox(width: 24),
                _DocumentTypeOption(
                  label: 'Passport',
                  selected: profile.idDocumentType == IdDocumentType.passport,
                  brandBlue: brandBlue,
                  onTap: () =>
                      notifier.setIdDocumentType(IdDocumentType.passport),
                ),
              ],
            ),
          ),
          _divider(brandBlue),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _idNumberController,
                    onChanged: notifier.setIdNumber,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: inputColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText:
                          'Please keep it consistent with the certificate',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: placeholderColor,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (profile.showValidUntil) ...[
            _divider(brandBlue),
            InkWell(
              onTap: _pickValidUntil,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        profile.validUntil != null
                            ? formatProfileDisplayDate(profile.validUntil!)
                            : 'Please select',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: profile.validUntil != null
                              ? inputColor
                              : placeholderColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: profile.validUntil != null
                          ? brandBlue
                          : placeholderColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider(Color brandBlue) {
    return Divider(
      height: 1,
      thickness: 1,
      color: brandBlue.withValues(alpha: 0.12),
    );
  }
}

class _DocumentTypeOption extends StatelessWidget {
  const _DocumentTypeOption({
    required this.label,
    required this.selected,
    required this.brandBlue,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color brandBlue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: brandBlue,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? brandBlue : Colors.transparent,
              border: Border.all(
                color: selected
                    ? brandBlue
                    : brandBlue.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: selected
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}
