import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/redeem/models/redeem_voucher_route_args.dart';
import 'package:neast/features/redeem/services/redeem_service.dart';
import 'package:neast/features/redeem/utils/voucher_code_util.dart';
import 'package:neast/features/scan/utils/qr_scanner_launcher.dart';
import 'package:neast/features/scan/utils/scan_gallery_util.dart';

/// 首页扫码页：不常驻相机，扫码框为按钮，点击后才打开扫码。
class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  static const _backgroundColor = Color(0xFFF2F9FC);

  Future<void> _submitCode(
    BuildContext context,
    WidgetRef ref,
    String raw, {
    required bool fromManual,
  }) async {
    final code = fromManual ? normalizeManualSn(raw) : normalizeScanCode(raw);
    if (code.isEmpty) return;

    if (fromManual && !validateManualSnOrToast(raw)) {
      return;
    }

    await EasyLoading.show();
    try {
      final preview = await ref.runGuarded(
        () => ref.read(redeemServiceProvider).verifyByCode(code),
      );
      if (!context.mounted || preview == null) return;
      context.push(
        AppRoutes.redeemVoucher,
        extra: RedeemVoucherRouteArgs(preview: preview, code: code),
      );
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _openScanner(BuildContext context, WidgetRef ref) async {
    final result = await openQrScanner(context);
    if (!context.mounted || result == null || result.isEmpty) return;
    await _submitCode(context, ref, result, fromManual: false);
  }

  Future<void> _pickFromGallery(BuildContext context, WidgetRef ref) async {
    final result = await pickQrFromGallery(context);
    if (!context.mounted || result == null || result.isEmpty) return;
    await _submitCode(context, ref, result, fromManual: false);
  }

  void _openManualInput(BuildContext context, WidgetRef ref) {
    _ManualInputDialog.show(
      onSubmit: (value) {
        if (value.isEmpty || !context.mounted) return;
        _submitCode(context, ref, value, fromManual: true);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: _ScanFrameButton(
                    onTap: () => _openScanner(context, ref),
                  ),
                ),
              ),
              _ScanBottomBar(
                onManual: () => _openManualInput(context, ref),
                onPhotos: () => _pickFromGallery(context, ref),
              ),
              const SizedBox(height: 39),
            ],
          ),
        ),
      ),
    );
  }
}

/// 扫码框按钮：四角边框 + 中心提示，点击打开扫码。
class _ScanFrameButton extends StatelessWidget {
  const _ScanFrameButton({required this.onTap});

  final VoidCallback onTap;

  static const double _size = 240;
  static const double _cornerLength = 36;
  static const double _cornerWidth = 4;
  static const Color _accent = Color(0xFF91CBE7);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _size,
        height: _size,
        child: Stack(
          children: [
            _corner(_accent, top: true, left: true),
            _corner(_accent, top: true, left: false),
            _corner(_accent, top: false, left: true),
            _corner(_accent, top: false, left: false),
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 56,
                    color: _accent,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Tap to scan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corner(Color color, {required bool top, required bool left}) {
    final border = BorderSide(color: color, width: _cornerWidth);
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: left ? 0 : null,
      right: left ? null : 0,
      child: SizedBox(
        width: _cornerLength,
        height: _cornerLength,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: top ? border : BorderSide.none,
              bottom: top ? BorderSide.none : border,
              left: left ? border : BorderSide.none,
              right: left ? BorderSide.none : border,
            ),
          ),
        ),
      ),
    );
  }
}

/// 底部栏：Scan 文案 + Manual / 门店信息卡 / Photos。
class _ScanBottomBar extends StatelessWidget {
  const _ScanBottomBar({
    required this.onManual,
    required this.onPhotos,
  });

  final VoidCallback onManual;
  final VoidCallback onPhotos;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'Scan QR / Receipt',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _CircleAction(
                icon: _ScanAssets.manual,
                label: 'Manual',
                onTap: onManual,
              ),
              const SizedBox(width: 26),
              const Expanded(child: _OutletInfoCard()),
              const SizedBox(width: 26),
              _CircleAction(
                icon: _ScanAssets.photos,
                label: 'Photos',
                onTap: onPhotos,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.66, -0.75),
            end: Alignment(0.66, 0.75),
            colors: [Color(0xFF4A97D4), Color(0xFF006EC0)],
          ),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, width: 22, height: 22),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 手动输入弹窗：输入用户手机或邮箱。
class _ManualInputDialog extends StatefulWidget {
  const _ManualInputDialog({required this.onSubmit});

  final ValueChanged<String> onSubmit;

  static Future<void> show({required ValueChanged<String> onSubmit}) {
    return SmartDialog.show(
      maskColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => _ManualInputDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<_ManualInputDialog> createState() => _ManualInputDialogState();
}

class _ManualInputDialogState extends State<_ManualInputDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    SmartDialog.dismiss();
    widget.onSubmit(value);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Transform.translate(
      offset: const Offset(0, -50),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Manual Entry',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            maxLength: 6,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(text: newValue.text.toUpperCase());
              }),
            ],
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: "Please enter the user's coupon code",
              hintStyle: TextStyle(
                fontSize: 12,
                color: brandBlue.withValues(alpha: 0.4),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: brandBlue.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: brandBlue),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: SmartDialog.dismiss,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: brandBlue,
                      side: BorderSide(color: brandBlue.withValues(alpha: 0.2)),
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
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
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
    );
  }
}

/// Scan 页图标资源。
abstract final class _ScanAssets {
  static const manual = 'assets/images/scan/manual.png';
  static const photos = 'assets/images/scan/photos.png';
}

/// 门店 / 收银员信息卡。
class _OutletInfoCard extends ConsumerWidget {
  const _OutletInfoCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;

    final info = ref.watch(merchantInfoProvider).value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: brandBlue,
              ),
              children: const [
                TextSpan(
                  text: 'neast',
                  style: TextStyle(
                    fontFamily: 'FD',
                    fontSize: 13,
                    fontVariations: [FontVariation('wght', 600)],
                  ),
                ),
                TextSpan(
                  text: 'merchants',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height:6),
          Text(
            info?.name  ?? '-',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 500)],
              height: 1.1,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 2),
          // Text(
          //   'Mei Yen · Cashier · STF-204',
          //   style: TextStyle(
          //     fontSize: 11,
          //     color: brandBlue.withValues(alpha: 0.4),
          //   ),
          // ),
        ],
      ),
    );
  }
}
