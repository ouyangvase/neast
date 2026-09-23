import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// 图片压缩工具，用于上传前减小体积。
abstract final class ImageCompressUtil {
  /// 长边上限，足够 OCR 与预览。
  static const int maxDimension = 1920;

  /// 文字清晰与体积的平衡点。
  static const int quality = 85;

  /// 已小于该体积则跳过压缩。
  static const int skipBelowBytes = 512 * 1024;

  /// 压缩图片文件；失败或收益不明显时返回原文件。
  static Future<File> compressImageFile(File source) async {
    final originalSize = await source.length();
    if (originalSize <= skipBelowBytes) {
      return source;
    }

    final outputPath = _buildOutputPath(source.path);
    try {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        source.absolute.path,
        outputPath,
        minWidth: maxDimension,
        minHeight: maxDimension,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        return source;
      }

      final compressedFile = File(compressed.path);
      if (!await compressedFile.exists()) {
        return source;
      }

      final compressedSize = await compressedFile.length();
      if (compressedSize >= originalSize) {
        await _safeDelete(compressedFile);
        return source;
      }

      return compressedFile;
    } catch (_) {
      await _safeDelete(File(outputPath));
      return source;
    }
  }

  static String _buildOutputPath(String sourcePath) {
    final fileName = sourcePath.split('/').last;
    final dotIndex = fileName.lastIndexOf('.');
    final baseName = dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
    final safeName = baseName.isNotEmpty ? baseName : 'compressed';
    return '${Directory.systemTemp.path}/${safeName}_compressed.jpg';
  }

  static Future<void> _safeDelete(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
