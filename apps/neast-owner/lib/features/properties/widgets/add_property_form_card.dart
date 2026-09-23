import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';
import 'package:neast_landlords/features/properties/properties_assets.dart';
import 'package:neast_landlords/features/properties/utils/property_file_picker.dart';
import 'package:neast_landlords/features/properties/widgets/property_list_card.dart';

/// 添加物业表单卡片。
class AddPropertyFormCard extends StatelessWidget {
  const AddPropertyFormCard({
    super.key,
    required this.propertyNameController,
    required this.addressController,
    this.photoFile,
    this.documentName,
    this.onPhotoTap,
    this.onDocumentTap,
  });

  final TextEditingController propertyNameController;
  final TextEditingController addressController;
  final File? photoFile;
  final String? documentName;
  final VoidCallback? onPhotoTap;
  final VoidCallback? onDocumentTap;

  static const _hintText = 'Please fill in';

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _InputRow(
            label: 'Property Name',
            controller: propertyNameController,
          ),
          const _FormDivider(),
          _InputRow(
            label: 'Address',
            controller: addressController,
          ),
          const _FormDivider(),
          _UploadRow(
            label: 'Photo',
            icon: PropertiesAssets.photoUpload,
            trailing: photoFile != null
                ? PropertyPhotoPreview(file: photoFile!)
                : null,
            onTap: onPhotoTap,
          ),
          const _FormDivider(),
          _UploadRow(
            label: 'Upload Document',
            icon: PropertiesAssets.docUpload,
            trailing: documentName != null && documentName!.isNotEmpty
                ? Text(
                    truncatePropertyFileName(documentName!),
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 400)],
                      color: context.appColors.brandBlue.withValues(alpha: 0.6),
                    ),
                  )
                : null,
            onTap: onDocumentTap,
          ),
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: brandBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 400)],
                color: brandBlue,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: AddPropertyFormCard._hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 400)],
                  color: HomeColors.label,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadRow extends StatelessWidget {
  const _UploadRow({
    required this.label,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  final String label;
  final String icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: brandBlue,
            ),
          ),
          const Spacer(),
          if (trailing != null) ...[
            trailing!,
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              icon,
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormDivider extends StatelessWidget {
  const _FormDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE8F0F8),
    );
  }
}
