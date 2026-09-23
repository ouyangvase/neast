import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/utils/toast_util.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';
import 'package:neast_landlords/features/account/widgets/bank_detail_form_card.dart';
import 'package:neast_landlords/features/common/widgets/neast_subpage_header_section.dart';
import 'package:neast_landlords/features/common/widgets/upload_progress_dialog.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/properties/utils/property_file_picker.dart';

/// 银行资料编辑页。
class BankDetailScreen extends ConsumerStatefulWidget {
  const BankDetailScreen({super.key});

  @override
  ConsumerState<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends ConsumerState<BankDetailScreen> {
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _accountHolderNameController = TextEditingController();

  File? _photoFile;
  String? _photoPath;
  String? _remotePhotoUrl;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingData());
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _accountHolderNameController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    await ref.read(landlordInfoProvider.notifier).fetchIfNeeded();
    if (!mounted || _initialized) {
      return;
    }

    final info = ref.read(landlordInfoProvider).value;
    if (info == null) {
      return;
    }

    setState(() {
      _bankNameController.text = info.bankName;
      _bankAccountController.text = info.bankAccount;
      _accountHolderNameController.text = info.accountHolderName;
      _photoPath = info.bankHeaderPhoto.isNotEmpty ? info.bankHeaderPhoto : null;
      _remotePhotoUrl =
          info.bankHeaderPhotoUrl.isNotEmpty ? info.bankHeaderPhotoUrl : null;
      _initialized = true;
    });
  }

  Future<void> _pickPhoto() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final picked = await pickPropertyPhoto(context);
    if (picked == null || !mounted) {
      return;
    }

    final uploaded = await uploadFileWithProgressDialog(
      context: context,
      ref: ref,
      file: picked.file,
      filename: picked.name,
    );
    if (!mounted || uploaded == null) {
      return;
    }

    setState(() {
      _photoFile = picked.file;
      _photoPath = uploaded.path;
      _remotePhotoUrl = uploaded.url.isNotEmpty ? uploaded.url : null;
    });
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final bankName = _bankNameController.text.trim();
    final bankAccount = _bankAccountController.text.trim();
    final accountHolderName = _accountHolderNameController.text.trim();

    if (bankName.isEmpty ||
        bankAccount.isEmpty ||
        accountHolderName.isEmpty) {
      ToastUtil.show('Please fill in all bank details');
      return;
    }
    if (_photoPath == null || _photoPath!.isEmpty) {
      ToastUtil.show('Please attach your bank header photo');
      return;
    }

    await EasyLoading.show(status: 'Submitting...');
    try {
      final success = await ref.read(landlordInfoProvider.notifier).updateBankDetail(
            bankName: bankName,
            bankAccount: bankAccount,
            accountHolderName: accountHolderName,
            bankHeaderPhoto: _photoPath!,
          );
      if (!mounted || !success) {
        return;
      }

      ToastUtil.show('Bank details saved');
      context.pop();
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastSubpageHeaderOverlapLayout(
            title: 'Bank detail',
            fillColor: HomeColors.background,
            overlapChild: BankDetailFormCard(
              bankNameController: _bankNameController,
              bankAccountController: _bankAccountController,
              accountHolderNameController: _accountHolderNameController,
              photoFile: _photoFile,
              remotePhotoUrl: _remotePhotoUrl,
              onPhotoTap: _pickPhoto,
            ),
          ),
          const Spacer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GestureDetector(
                onTap: _submit,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: brandBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 500)],
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
