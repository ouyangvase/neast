import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/account/models/personal_data_field.dart';
import 'package:neast/features/account/models/user_profile_model.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/account/widgets/personal_data_field_row.dart';
import 'package:neast/features/auth/widgets/profile_date_picker_sheet.dart';
import 'package:neast/features/rich_text/widgets/rich_text_header.dart';

/// 个人资料页面。
class PersonalDataScreen extends ConsumerStatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  ConsumerState<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends ConsumerState<PersonalDataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).fetchIfNeeded();
    });
  }

  String _displayValue(String value) {
    return value.trim().isEmpty ? '-' : value.trim();
  }

  String _displayValidUntil(UserProfileModel profile) {
    if (profile.idValidUntil == null || profile.idValidUntil!.isEmpty) {
      return '-';
    }
    final date = DateTime.tryParse(profile.idValidUntil!);
    if (date == null) {
      return profile.idValidUntil!;
    }
    return formatProfileDisplayDate(date);
  }

  void _openEdit(PersonalDataField field) {
    context.push(AppRoutes.personalDataEdit, extra: field);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RichTextHeader(title: 'Personal data'),
          Expanded(
            child: profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(
                child: Text('Failed to load profile'),
              ),
              data: (profile) {
                if (profile == null) {
                  return const Center(child: Text('No profile data'));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        PersonalDataFieldRow(
                          label: 'First name',
                          value: _displayValue(profile.firstName),
                          onTap: () => _openEdit(PersonalDataField.firstName),
                        ),
                        PersonalDataFieldRow(
                          label: 'Last name',
                          value: _displayValue(profile.lastName),
                          onTap: () => _openEdit(PersonalDataField.lastName),
                        ),
                        PersonalDataFieldRow(
                          label: profile.accountLabel,
                          value: _displayValue(profile.account),
                          editable: false,
                        ),
                        PersonalDataFieldRow(
                          label: 'Email',
                          value: _displayValue(profile.email),
                          onTap: () => _openEdit(PersonalDataField.email),
                        ),
                        PersonalDataFieldRow(
                          label: 'ID document type',
                          value: profile.idTypeLabel,
                          editable: false,
                        ),
                        PersonalDataFieldRow(
                          label: 'ID number',
                          value: _displayValue(profile.idNumber),
                          editable: false,
                        ),
                        if (!profile.isIdCard)
                          PersonalDataFieldRow(
                            label: 'Valid until',
                            value: _displayValidUntil(profile),
                            onTap: () => _openEdit(PersonalDataField.validUntil),
                          ),
                        PersonalDataFieldRow(
                          label: 'Current address',
                          value: _displayValue(profile.address),
                          showDivider: false,
                          onTap: () => _openEdit(PersonalDataField.address),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
