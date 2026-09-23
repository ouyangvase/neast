import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/common/widgets/upload_progress_dialog.dart';
import 'package:neast/features/give_points/models/receipt_capture_result.dart';
import 'package:neast/features/common/utils/permission_denied_dialog.dart';
import 'package:neast/features/give_points/services/receipt_capture_service.dart';
import 'package:neast/features/give_points/utils/receipt_capture_sheet.dart';

Future<void> _openReceiptDetails(
  BuildContext context,
  ReceiptCaptureResult result,
) async {
  if (!context.mounted) return;
  if (!result.hasUploaded) {
    ToastUtil.showError('Failed to upload receipt image.');
    return;
  }
  // 关弹窗与 push 分帧执行：等当前帧（弹窗退场）结束后再导航，
  // 避免与转场竞争导致进入详情页时白屏。
  await WidgetsBinding.instance.endOfFrame;
  if (!context.mounted) return;
  await context.push(AppRoutes.receiptDetails, extra: result);
}

Future<void> _handleCaptureError(
  BuildContext context,
  ReceiptCaptureException error,
) async {
  if (!context.mounted) return;

  if (error.permanentlyDenied) {
    await showPermissionDeniedDialog(
      context,
      title: error.dialogTitle,
      message: error.resolvedDialogMessage,
      icon: error.dialogIcon,
      reasons: error.dialogReasons,
      settingsHint: error.dialogSettingsHint,
    );
    return;
  }

  ToastUtil.showError(error.message);
}

Future<ReceiptCaptureResult?> _runCapture(
  Future<ReceiptCaptureResult?> Function() action,
) async {
  try {
    return await action();
  } on ReceiptCaptureException {
    rethrow;
  } catch (_) {
    throw const ReceiptCaptureException('Failed to capture receipt.');
  }
}

Future<void> _captureUploadAndOpen(
  BuildContext context,
  WidgetRef ref,
  Future<ReceiptCaptureResult?> Function() captureAction,
) async {
  try {
    final local = await _runCapture(captureAction);
    if (!context.mounted || local == null) return;

    final imagePath = local.imagePath;
    if (imagePath == null || imagePath.isEmpty) {
      ToastUtil.showError('Failed to read receipt image.');
      return;
    }

    final uploaded = await uploadFileWithProgressDialog(
      context: context,
      ref: ref,
      file: File(imagePath),
      filename: local.fileName,
    );
    if (!context.mounted) return;
    if (uploaded == null) return;

    final result = local.withUploaded(
      imageUrl: uploaded.url,
      uploadPath: uploaded.path,
      fileName: uploaded.name.isNotEmpty ? uploaded.name : local.fileName,
    );
    await _openReceiptDetails(context, result);
  } on ReceiptCaptureException catch (e) {
    if (context.mounted) {
      await _handleCaptureError(context, e);
    }
  }
}

/// 直接打开文档扫描，上传成功后进入 Receipt Details。
Future<void> startReceiptDocumentScan(
  BuildContext context,
  WidgetRef ref,
) async {
  await _captureUploadAndOpen(
    context,
    ref,
    ReceiptCaptureService.scanDocument,
  );
}

/// 相机图标：BottomSheet 选择扫描或相册。
Future<void> showReceiptCaptureOptions(
  BuildContext context,
  WidgetRef ref,
) async {
  final source = await showReceiptCaptureSheet(context);
  if (!context.mounted || source == null) return;

  await _captureUploadAndOpen(context, ref, () async {
    switch (source) {
      case ReceiptCaptureSource.scan:
        return ReceiptCaptureService.scanDocument();
      case ReceiptCaptureSource.gallery:
        return ReceiptCaptureService.pickFromGallery();
    }
  });
}
