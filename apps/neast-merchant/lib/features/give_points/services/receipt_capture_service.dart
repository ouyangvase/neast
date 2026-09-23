import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/utils/image_compress_util.dart';
import 'package:neast/features/common/utils/camera_permission_util.dart';
import 'package:neast/features/give_points/models/receipt_capture_result.dart';
import 'package:permission_handler/permission_handler.dart';

/// 凭证采集失败（权限拒绝、插件异常等）。
class ReceiptCaptureException implements Exception {
  const ReceiptCaptureException(
    this.message, {
    this.permanentlyDenied = false,
    this.dialogTitle = 'Permission Required',
    this.dialogMessage,
    this.dialogIcon = Icons.lock_outline_rounded,
    this.dialogReasons = const [],
    this.dialogSettingsHint =
        'If you previously denied access, enable the permission in Settings.',
  });

  final String message;
  final bool permanentlyDenied;
  final String dialogTitle;
  final String? dialogMessage;
  final IconData dialogIcon;
  final List<String> dialogReasons;
  final String dialogSettingsHint;

  String get resolvedDialogMessage => dialogMessage ?? message;

  @override
  String toString() => message;
}

/// 凭证扫描与相册选取。
abstract final class ReceiptCaptureService {
  static final _imagePicker = ImagePicker();

  /// 打开文档扫描（iOS VisionKit / Android ML Kit），失败时降级普通相机。
  static Future<ReceiptCaptureResult?> scanDocument() async {
    await _ensureCameraPermission();

    try {
      final paths = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
        isGalleryImportAllowed: false,
      );
      if (paths != null && paths.isNotEmpty) {
        return _fromPath(paths.first);
      }
      return null;
    } on CunningDocumentScannerException catch (e) {
      if (e.code == 'permission_denied') {
        final status = await Permission.camera.status;
        throw ReceiptCaptureException(
          e.message,
          permanentlyDenied: status.isPermanentlyDenied,
          dialogTitle: 'Camera Access Required',
          dialogIcon: Icons.camera_alt_outlined,
          dialogMessage:
              'NEAST uses your camera to scan customer receipts when awarding points.',
          dialogReasons: const [
            'Capture receipt details quickly at checkout',
            'Verify purchase amount for accurate point calculation',
            'Images are used only for receipt processing',
          ],
          dialogSettingsHint:
              'If you previously denied camera access, enable Camera in Settings to scan receipts.',
        );
      }
      return _pickFromCamera();
    } catch (_) {
      return _pickFromCamera();
    }
  }

  /// 从相册选取一张图片。
  static Future<ReceiptCaptureResult?> pickFromGallery() async {
    try {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        return null;
      }
      return _savePickedFile(picked);
    } on ReceiptCaptureException {
      rethrow;
    } catch (_) {
      throw const ReceiptCaptureException('Failed to pick image from gallery.');
    }
  }

  static Future<void> _ensureCameraPermission() async {
    try {
      await CameraPermissionUtil.ensureGranted();
    } on CameraPermissionException catch (e) {
      throw ReceiptCaptureException(
        e.permanentlyDenied
            ? 'Camera permission denied. Please enable it in Settings.'
            : 'Camera permission is required to scan receipts.',
        permanentlyDenied: e.permanentlyDenied,
        dialogTitle: 'Camera Access Required',
        dialogIcon: Icons.camera_alt_outlined,
        dialogMessage:
            'NEAST uses your camera to scan customer receipts when awarding points.',
        dialogReasons: const [
          'Capture receipt details quickly at checkout',
          'Verify purchase amount for accurate point calculation',
          'Images are used only for receipt processing',
        ],
        dialogSettingsHint:
            'If you previously denied camera access, enable Camera in Settings to scan receipts.',
      );
    }
  }

  static Future<ReceiptCaptureResult?> _pickFromCamera() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (picked == null) {
        return null;
      }
      return _savePickedFile(picked);
    } catch (_) {
      throw const ReceiptCaptureException('Failed to open camera.');
    }
  }

  static Future<ReceiptCaptureResult> _savePickedFile(XFile picked) async {
    final bytes = await picked.readAsBytes();
    final name = picked.name.isNotEmpty
        ? picked.name
        : 'Receipt_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.jpg';
    final tempFile = File('${Directory.systemTemp.path}/$name');
    await tempFile.writeAsBytes(bytes, flush: true);
    return _prepareForUpload(tempFile.path, fileName: name, deleteSource: true);
  }

  static Future<ReceiptCaptureResult> _fromPath(
    String path, {
    String? fileName,
  }) async {
    return _prepareForUpload(path, fileName: fileName);
  }

  static Future<ReceiptCaptureResult> _prepareForUpload(
    String path, {
    String? fileName,
    bool deleteSource = false,
  }) async {
    final sourceFile = File(path);
    final compressedFile = await ImageCompressUtil.compressImageFile(sourceFile);

    if (deleteSource &&
        compressedFile.path != sourceFile.path &&
        await sourceFile.exists()) {
      try {
        await sourceFile.delete();
      } catch (_) {}
    }

    final stat = await compressedFile.stat();
    final resolvedName = _resolveFileName(
      fileName ?? path.split('/').last,
    );

    return ReceiptCaptureResult(
      imagePath: compressedFile.path,
      fileName: resolvedName,
      fileSizeBytes: stat.size,
      capturedAt: stat.modified,
    );
  }

  static String _resolveFileName(String fileName) {
    if (fileName.isEmpty) {
      return _defaultFileName();
    }

    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0) {
      return '$fileName.jpg';
    }

    final extension = fileName.substring(dotIndex + 1).toLowerCase();
    if (extension == 'jpg' || extension == 'jpeg') {
      return fileName;
    }

    return '${fileName.substring(0, dotIndex)}.jpg';
  }

  static String _defaultFileName() {
    return 'Receipt_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.jpg';
  }
}
