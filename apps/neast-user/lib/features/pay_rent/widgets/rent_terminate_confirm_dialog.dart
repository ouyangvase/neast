import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 终止租约确认弹窗，Terminate 按钮需倒计时 5 秒后可点击。
class RentTerminateConfirmDialog extends StatefulWidget {
  const RentTerminateConfirmDialog({
    super.key,
    this.onConfirm,
  });

  final VoidCallback? onConfirm;

  static Future<void> show({VoidCallback? onConfirm}) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => RentTerminateConfirmDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<RentTerminateConfirmDialog> createState() =>
      _RentTerminateConfirmDialogState();
}

class _RentTerminateConfirmDialogState extends State<RentTerminateConfirmDialog> {
  static const _countdownSeconds = 5;
  static const _dangerColor = Color(0xFFFF4444);

  Timer? _timer;
  int _countdown = _countdownSeconds;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _dismiss() => SmartDialog.dismiss();

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final canConfirm = _countdown == 0;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terminate Rent',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This will cancel all unpaid payment schedules. '
                  'The rent will be hidden from the app, but paid/settled '
                  'records remain in history.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: brandBlue.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: _dismiss,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: brandBlue,
                            side: BorderSide(
                              color: brandBlue.withValues(alpha: 0.2),
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: canConfirm
                              ? () {
                                  _dismiss();
                                  widget.onConfirm?.call();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _dangerColor,
                            disabledBackgroundColor:
                                _dangerColor.withValues(alpha: 0.4),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white70,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            canConfirm
                                ? 'Terminate'
                                : 'Terminate(${_countdown}s)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
            onTap: _dismiss,
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
    );
  }
}
