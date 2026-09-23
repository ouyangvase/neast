import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/common/models/upload_file_result.dart';

typedef UploadProgressCallback = void Function(double progress);

/// 用户主动取消上传。
class UploadCancelledException implements Exception {
  const UploadCancelledException();

  @override
  String toString() => 'Upload cancelled';
}

class UploadService {
  UploadService(this._dioClient);

  final DioClient _dioClient;

  /// 分片大小 256KB；超过该大小走分片并发上传。
  static const int chunkSize = 256 * 1024;

  /// 并发上传分片数。
  static const int maxConcurrency = 8;

  /// 上传文件，返回服务端可访问 URL。
  Future<UploadFileResult> uploadFile(
    File file, {
    String? filename,
    CancelToken? cancelToken,
    UploadProgressCallback? onProgress,
  }) async {
    _throwIfCancelled(cancelToken);

    final name = _resolveFilename(file, filename);
    final fileLength = await file.length();

    if (fileLength <= chunkSize) {
      return _uploadSingle(
        file,
        name,
        fileLength: fileLength,
        cancelToken: cancelToken,
        onProgress: onProgress,
      );
    }

    return _uploadChunked(
      file,
      name,
      fileLength,
      cancelToken: cancelToken,
      onProgress: onProgress,
    );
  }

  Future<UploadFileResult> _uploadSingle(
    File file,
    String filename, {
    required int fileLength,
    CancelToken? cancelToken,
    UploadProgressCallback? onProgress,
  }) async {
    final multipart = await MultipartFile.fromFile(
      file.path,
      filename: filename,
    );
    final formData = FormData.fromMap({'file': multipart});

    final response = await _dioClient.uploadFile(
      '/merchant/upload/file',
      formData,
      cancelToken: cancelToken,
      onSendProgress: (sent, total) {
        final denominator = total > 0 ? total : fileLength;
        if (denominator <= 0) return;
        onProgress?.call(sent / denominator);
      },
    );

    onProgress?.call(1);
    return _extractResult(response);
  }

  Future<UploadFileResult> _uploadChunked(
    File file,
    String filename,
    int fileLength, {
    CancelToken? cancelToken,
    UploadProgressCallback? onProgress,
  }) async {
    final uploadId = _generateUploadId();
    final totalChunks = (fileLength / chunkSize).ceil();
    var nextChunkIndex = 0;
    var completedBytes = 0;

    void reportProgress() {
      if (fileLength <= 0) return;
      onProgress?.call(completedBytes / fileLength);
    }

    Future<void> worker() async {
      while (true) {
        _throwIfCancelled(cancelToken);

        final chunkIndex = nextChunkIndex++;
        if (chunkIndex >= totalChunks) {
          break;
        }

        final start = chunkIndex * chunkSize;
        final length = min(chunkSize, fileLength - start);
        final bytes = await _readFileBytes(file, start, length);

        await _uploadChunk(
          uploadId: uploadId,
          chunkIndex: chunkIndex,
          totalChunks: totalChunks,
          filename: filename,
          bytes: bytes,
          cancelToken: cancelToken,
        );

        completedBytes += length;
        reportProgress();
      }
    }

    await Future.wait(
      List.generate(maxConcurrency, (_) => worker()),
    );

    _throwIfCancelled(cancelToken);

    final response = await _dioClient.post(
      '/merchant/upload/merge',
      data: {
        'upload_id': uploadId,
        'total_chunks': totalChunks,
        'filename': filename,
      },
      cancelToken: cancelToken,
    );

    onProgress?.call(1);
    return _extractResult(response);
  }

  Future<Uint8List> _readFileBytes(File file, int start, int length) async {
    final raf = await file.open(mode: FileMode.read);
    try {
      await raf.setPosition(start);
      return await raf.read(length);
    } finally {
      await raf.close();
    }
  }

  Future<void> _uploadChunk({
    required String uploadId,
    required int chunkIndex,
    required int totalChunks,
    required String filename,
    required Uint8List bytes,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({
      'upload_id': uploadId,
      'chunk_index': chunkIndex,
      'total_chunks': totalChunks,
      'filename': filename,
      'file': MultipartFile.fromBytes(
        bytes,
        filename: 'chunk_$chunkIndex',
      ),
    });

    await _dioClient.uploadFile(
      '/merchant/upload/chunk',
      formData,
      cancelToken: cancelToken,
    );
  }

  void _throwIfCancelled(CancelToken? cancelToken) {
    if (cancelToken?.isCancelled == true) {
      throw const UploadCancelledException();
    }
  }

  String _resolveFilename(File file, String? filename) {
    final name = filename?.trim().isNotEmpty == true
        ? filename!.trim()
        : file.uri.pathSegments.last;
    return name.isNotEmpty ? name : 'file';
  }

  String _generateUploadId() {
    final random = Random();
    final suffix = random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '${DateTime.now().millisecondsSinceEpoch}_$suffix';
  }

  UploadFileResult _extractResult(dynamic response) {
    if (response is! Map) {
      return const UploadFileResult(url: '', path: '', name: '');
    }

    final responseMap = Map<String, dynamic>.from(response);
    final rawData = responseMap['data'];
    if (rawData is! Map) {
      return const UploadFileResult(url: '', path: '', name: '');
    }

    return UploadFileResult.fromJson(Map<String, dynamic>.from(rawData));
  }
}

final uploadServiceProvider = Provider<UploadService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UploadService(dioClient);
});
