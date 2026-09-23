import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

enum ReceiptCaptureSource {
  scan,
  gallery,
}

/// 相机图标点击：选择扫描或相册。
Future<ReceiptCaptureSource?> showReceiptCaptureSheet(BuildContext context) {
  final brandBlue = context.appColors.brandBlue;

  return showModalBottomSheet<ReceiptCaptureSource>(
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
              leading: Icon(Icons.camera_alt_outlined, color: brandBlue),
              title: const Text('Scan with camera'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(ReceiptCaptureSource.scan),
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: brandBlue),
              title: const Text('Choose from gallery'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(ReceiptCaptureSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
