/// 凭证拍摄/选取结果，用于路由 extra 传递。
class ReceiptCaptureResult {
  const ReceiptCaptureResult({
    this.imageUrl = '',
    this.uploadPath = '',
    this.imagePath,
    required this.fileName,
    required this.fileSizeBytes,
    required this.capturedAt,
  });

  /// 上传后的可访问 URL；进入详情页前应有值。
  final String imageUrl;

  /// 上传接口返回的服务端存储路径。
  final String uploadPath;

  /// 本地临时文件路径（采集阶段）。
  final String? imagePath;
  final String fileName;
  final int fileSizeBytes;
  final DateTime capturedAt;

  bool get hasUploaded => imageUrl.isNotEmpty && uploadPath.isNotEmpty;

  ReceiptCaptureResult withUploaded({
    required String imageUrl,
    required String uploadPath,
    String? fileName,
  }) {
    return ReceiptCaptureResult(
      imageUrl: imageUrl,
      uploadPath: uploadPath,
      imagePath: imagePath,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes,
      capturedAt: capturedAt,
    );
  }

  String get formattedFileSize {
    if (fileSizeBytes < 1024) {
      return '$fileSizeBytes B';
    }
    final kb = fileSizeBytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(kb >= 100 ? 0 : 1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}
