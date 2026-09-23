import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/account/account_assets.dart';

/// 删除账号确认弹窗，OK 按钮需倒计时 10 秒后可点击。
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
    this.onConfirm,
  });

  final VoidCallback? onConfirm;

  static Future<void> show({VoidCallback? onConfirm}) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      clickMaskDismiss: false,
      builder: (_) => DeleteAccountDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  static const _countdownSeconds = 10;

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
                _buildIllustration(),
                const SizedBox(height: 50),
                Text(
                  'We are sad that you want to leave us, but please note that account deletion is irreversible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
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
                              borderRadius: BorderRadius.circular(6),
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
                            backgroundColor: brandBlue,
                            disabledBackgroundColor:
                                brandBlue.withValues(alpha: 0.4),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white70,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            canConfirm ? 'OK' : 'OK(${_countdown}s)',
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

  Widget _buildIllustration() {
    return Image.asset(
      AccountAssets.deleteAccountPhone,
      width: 180,
      fit: BoxFit.contain,
    );
  }
}
