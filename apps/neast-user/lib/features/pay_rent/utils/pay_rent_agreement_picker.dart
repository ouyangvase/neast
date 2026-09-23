import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 从相册或文件夹选取租约文件。
Future<({File file, String name})?> pickTenancyAgreement(
  BuildContext context,
) async {
  final brandBlue = context.appColors.brandBlue;
  final source = await showModalBottomSheet<_AgreementSource>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: brandBlue),
              title: const Text('Photo Library'),
              onTap: () => Navigator.of(sheetContext)
                  .pop(_AgreementSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.folder_outlined, color: brandBlue),
              title: const Text('Browse Files'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_AgreementSource.files),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );

  if (source == null || !context.mounted) return null;

  switch (source) {
    case _AgreementSource.gallery:
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return null;
      final bytes = await picked.readAsBytes();
      final name = picked.name.isNotEmpty
          ? picked.name
          : 'agreement.heic';
      final tempFile = File('${Directory.systemTemp.path}/$name');
      await tempFile.writeAsBytes(bytes, flush: true);
      return (file: tempFile, name: name);
    case _AgreementSource.files:
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return null;
      final platformFile = result.files.single;
      final path = platformFile.path;
      if (path == null || path.isEmpty) return null;
      final file = File(path);
      final name = platformFile.name.isNotEmpty
          ? platformFile.name
          : file.path.split('/').last;
      return (file: file, name: name);
  }
}

enum _AgreementSource {
  gallery,
  files,
}

String truncateFileName(String name, {int maxLength = 18}) {
  if (name.length <= maxLength) return name;
  final extIndex = name.lastIndexOf('.');
  if (extIndex <= 0) {
    return '${name.substring(0, maxLength - 3)}...';
  }
  final ext = name.substring(extIndex);
  final baseMax = maxLength - ext.length - 3;
  if (baseMax <= 0) return name;
  return '${name.substring(0, baseMax)}...$ext';
}
