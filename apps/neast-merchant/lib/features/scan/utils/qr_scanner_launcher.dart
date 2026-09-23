import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/common/utils/camera_permission_util.dart';
import 'package:neast/features/common/utils/permission_denied_dialog.dart';

/// 进入全屏扫码页，成功时返回扫码内容。
Future<String?> openQrScanner(BuildContext context) async {
  try {
    await CameraPermissionUtil.ensureGranted();
  } on CameraPermissionException catch (e) {
    if (!context.mounted) {
      return null;
    }
    if (e.permanentlyDenied) {
      await showCameraScanPermissionDeniedDialog(context);
    } else {
      ToastUtil.showError(e.message);
    }
    return null;
  }

  if (!context.mounted) {
    return null;
  }

  return context.push<String>(AppRoutes.scanner);
}
