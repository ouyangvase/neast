import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:neast/core/utils/toast_util.dart';

/// 从相册选择图片并识别其中的二维码，成功时返回二维码内容。
Future<String?> pickQrFromGallery(BuildContext context) async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return null;

  final controller = MobileScannerController();
  try {
    final capture = await controller.analyzeImage(picked.path);
    final value = _extractRawValue(capture);
    if (value == null || value.isEmpty) {
      ToastUtil.showError('No QR code found in the selected image.');
      return null;
    }
    return value;
  } catch (_) {
    ToastUtil.showError('Failed to read QR code from gallery.');
    return null;
  } finally {
    await controller.dispose();
  }
}

String? _extractRawValue(BarcodeCapture? capture) {
  if (capture == null) return null;
  for (final barcode in capture.barcodes) {
    final rawValue = barcode.rawValue?.trim();
    if (rawValue != null && rawValue.isNotEmpty) {
      return rawValue;
    }
  }
  return null;
}
