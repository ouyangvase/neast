import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/utils/toast_util.dart';
import 'package:neast_landlords/features/common/widgets/upload_progress_dialog.dart';
import 'package:neast_landlords/features/common/widgets/neast_subpage_header_section.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/properties/providers/property_list_provider.dart';
import 'package:neast_landlords/features/properties/services/property_service.dart';
import 'package:neast_landlords/features/properties/utils/property_file_picker.dart';
import 'package:neast_landlords/features/properties/widgets/add_property_form_card.dart';
import 'package:neast_landlords/features/properties/widgets/add_property_success_dialog.dart';

/// 添加物业页面。
class AddPropertyScreen extends ConsumerStatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  ConsumerState<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends ConsumerState<AddPropertyScreen> {
  final _propertyNameController = TextEditingController();
  final _addressController = TextEditingController();

  File? _photoFile;
  String? _photoPath;
  String? _documentName;
  String? _documentPath;

  @override
  void dispose() {
    _propertyNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final picked = await pickPropertyPhoto(context);
    if (picked == null || !mounted) return;

    final uploaded = await uploadFileWithProgressDialog(
      context: context,
      ref: ref,
      file: picked.file,
      filename: picked.name,
    );
    if (!mounted) return;
    if (uploaded == null) return;

    setState(() {
      _photoFile = picked.file;
      _photoPath = uploaded.path;
    });
  }

  Future<void> _pickDocument() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await pickPropertyDocument(context);
    if (picked == null || !mounted) return;

    final uploaded = await uploadFileWithProgressDialog(
      context: context,
      ref: ref,
      file: picked.file,
      filename: picked.name,
    );
    if (!mounted) return;
    if (uploaded == null) return;

    setState(() {
      _documentName = uploaded.name.isNotEmpty ? uploaded.name : picked.name;
      _documentPath = uploaded.path;
    });
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final name = _propertyNameController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty || address.isEmpty) {
      ToastUtil.show('Please fill in property name and address');
      return;
    }
    if (_photoPath == null || _photoPath!.isEmpty) {
      ToastUtil.show('Please upload a photo');
      return;
    }
    if (_documentPath == null || _documentPath!.isEmpty) {
      ToastUtil.show('Please upload a document');
      return;
    }

    await EasyLoading.show(status: 'Submitting...');
    try {
      await ref.read(propertyServiceProvider).create(
            name: name,
            address: address,
            image: _photoPath!,
            file: _documentPath!,
          );

      if (!mounted) return;
      await ref.read(propertyListProvider.notifier).refresh();
      await AddPropertySuccessDialog.show();
      if (!mounted) return;
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
            title: 'Add Property',
            fillColor: HomeColors.background,
            overlapChild: AddPropertyFormCard(
              propertyNameController: _propertyNameController,
              addressController: _addressController,
              photoFile: _photoFile,
              documentName: _documentName,
              onPhotoTap: _pickPhoto,
              onDocumentTap: _pickDocument,
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
