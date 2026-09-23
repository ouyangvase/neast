import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';
import 'package:neast_landlords/features/properties/properties_assets.dart';
import 'package:neast_landlords/features/properties/widgets/property_list_card.dart';

/// 银行资料表单卡片。
class BankDetailFormCard extends StatelessWidget {
  const BankDetailFormCard({
    super.key,
    required this.bankNameController,
    required this.bankAccountController,
    required this.accountHolderNameController,
    this.photoFile,
    this.remotePhotoUrl,
    this.onPhotoTap,
  });

  final TextEditingController bankNameController;
  final TextEditingController bankAccountController;
  final TextEditingController accountHolderNameController;
  final File? photoFile;
  final String? remotePhotoUrl;
  final VoidCallback? onPhotoTap;

  static const _hintText = 'Please fill in';

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _InputRow(
            label: 'Bank Name',
            controller: bankNameController,
          ),
          const _FormDivider(),
          _InputRow(
            label: 'Bank Account Number',
            controller: bankAccountController,
          ),
          const _FormDivider(),
          _InputRow(
            label: 'Account Holder Name',
            controller: accountHolderNameController,
          ),
          const _FormDivider(),
          _PhotoUploadRow(
            photoFile: photoFile,
            remotePhotoUrl: remotePhotoUrl,
            onTap: onPhotoTap,
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
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 400)],
                color: brandBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
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
                hintText: BankDetailFormCard._hintText,
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

class _PhotoUploadRow extends StatelessWidget {
  const _PhotoUploadRow({
    this.photoFile,
    this.remotePhotoUrl,
    this.onTap,
  });

  final File? photoFile;
  final String? remotePhotoUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    Widget? preview;
    if (photoFile != null) {
      preview = PropertyPhotoPreview(file: photoFile!);
    } else if (remotePhotoUrl != null && remotePhotoUrl!.isNotEmpty) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: remotePhotoUrl!,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: 30,
            height: 30,
            color: brandBlue.withValues(alpha: 0.08),
          ),
          errorWidget: (_, __, ___) => Container(
            width: 30,
            height: 30,
            color: brandBlue.withValues(alpha: 0.08),
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 16,
              color: brandBlue.withValues(alpha: 0.4),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Please attach your bank header photo together.',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 400)],
                color: brandBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (preview != null) ...[
            preview,
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              PropertiesAssets.photoUpload,
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
