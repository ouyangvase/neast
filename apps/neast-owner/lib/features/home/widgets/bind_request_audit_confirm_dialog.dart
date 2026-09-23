import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_colors.dart';

/// 待绑定申请审核确认弹窗。
class BindRequestAuditConfirmDialog extends StatelessWidget {
  const BindRequestAuditConfirmDialog({
    super.key,
    required this.isReject,
    required this.onCancel,
    required this.onConfirm,
  });

  final bool isReject;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  static const horizontalInset = 37.0;

  static Future<bool> show({required bool isReject}) {
    final completer = Completer<bool>();

    SmartDialog.show<void>(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => BindRequestAuditConfirmDialog(
        isReject: isReject,
        onCancel: () {
          if (!completer.isCompleted) {
            completer.complete(false);
          }
          SmartDialog.dismiss<void>();
        },
        onConfirm: () {
          if (!completer.isCompleted) {
            completer.complete(true);
          }
          SmartDialog.dismiss<void>();
        },
      ),
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final accentColor = isReject ? HomeColors.reject : brandBlue;
    final dialogWidth =
        MediaQuery.sizeOf(context).width - horizontalInset * 2;

    return Center(
      child: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isReject
                          ? Icons.close_rounded
                          : Icons.check_rounded,
                      size: 28,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isReject ? 'Reject request?' : 'Approve request?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 600)],
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isReject
                        ? 'Are you sure you want to reject this bind request? This action cannot be undone.'
                        : 'After approval, this request will be sent to the platform for final review.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 400)],
                      color: brandBlue.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: brandBlue,
                              side: BorderSide(
                                color: brandBlue.withValues(alpha: 0.2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'HG',
                                fontVariations: [FontVariation('wght', 500)],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              isReject ? 'Reject' : 'Approve',
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'HG',
                                fontVariations: [FontVariation('wght', 500)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onCancel,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
