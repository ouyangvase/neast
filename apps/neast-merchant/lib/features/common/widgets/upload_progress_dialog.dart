import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/common/models/upload_file_result.dart';
import 'package:neast/features/common/services/upload_service.dart';

/// 上传进度弹窗：展示进度条，支持取消中断。
class UploadProgressDialog extends StatelessWidget {
  const UploadProgressDialog({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  final ValueNotifier<double> progress;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Uploading',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: brandBlue,
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, _) {
                final percent = (value.clamp(0, 1) * 100).round();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: value.clamp(0, 1),
                        minHeight: 6,
                        backgroundColor: brandBlue.withValues(alpha: 0.12),
                        color: brandBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$percent%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: brandBlue.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: brandBlue.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 弹窗内展示上传进度；取消或失败返回 null。
Future<UploadFileResult?> uploadFileWithProgressDialog({
  required BuildContext context,
  required WidgetRef ref,
  required File file,
  String? filename,
}) async {
  final cancelToken = CancelToken();
  final progress = ValueNotifier<double>(0);
  var progressActive = true;
  UploadFileResult? result;
  var cancelled = false;

  void updateProgress(double value) {
    if (!progressActive) return;
    progress.value = value;
  }

  try {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        var dialogClosed = false;

        Future<void> closeDialog() async {
          if (dialogClosed || !dialogContext.mounted) return;
          dialogClosed = true;
          // 上传秒回时，弹窗入场动画可能尚未结束。此时直接 pop 会与转场
          // 竞争，导致随后 push 的页面出现白屏。先等入场动画结束再关闭。
          final animation = ModalRoute.of(dialogContext)?.animation;
          if (animation != null &&
              animation.status != AnimationStatus.completed &&
              animation.status != AnimationStatus.dismissed) {
            final completer = Completer<void>();
            void onStatus(AnimationStatus status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                animation.removeStatusListener(onStatus);
                if (!completer.isCompleted) completer.complete();
              }
            }

            animation.addStatusListener(onStatus);
            await completer.future;
          }
          if (!dialogContext.mounted) return;
          Navigator.of(dialogContext).pop();
        }

        Future<void>(() async {
          try {
            result = await ref.read(uploadServiceProvider).uploadFile(
                  file,
                  filename: filename,
                  cancelToken: cancelToken,
                  onProgress: updateProgress,
                );
          } on UploadCancelledException {
            cancelled = true;
          } on DioException catch (e) {
            if (CancelToken.isCancel(e)) {
              cancelled = true;
            } else {
              ToastUtil.show(e.error?.toString() ?? 'Upload failed.');
            }
          } catch (e, stack) {
            debugPrint('Upload failed: $e\n$stack');
            ToastUtil.showError('Upload failed.');
          } finally {
            progressActive = false;
            closeDialog();
          }
        });

        return UploadProgressDialog(
          progress: progress,
          onCancel: () {
            if (!cancelToken.isCancelled) {
              cancelToken.cancel('User cancelled upload');
            }
          },
        );
      },
    );
  } finally {
    progressActive = false;
    progress.dispose();
  }

  if (cancelled) return null;
  if (result == null || result!.url.isEmpty) return null;
  return result;
}
