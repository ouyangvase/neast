import 'package:permission_handler/permission_handler.dart';

/// 相机权限被拒绝。
class CameraPermissionException implements Exception {
  const CameraPermissionException(
    this.message, {
    this.permanentlyDenied = false,
  });

  final String message;
  final bool permanentlyDenied;

  @override
  String toString() => message;
}

/// 相机权限检查。
abstract final class CameraPermissionUtil {
  static Future<void> ensureGranted() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return;
    }
    status = await Permission.camera.request();
    if (status.isGranted) {
      return;
    }
    throw CameraPermissionException(
      status.isPermanentlyDenied
          ? 'Camera permission denied. Please enable it in Settings.'
          : 'Camera permission is required to scan QR codes.',
      permanentlyDenied: status.isPermanentlyDenied,
    );
  }
}
