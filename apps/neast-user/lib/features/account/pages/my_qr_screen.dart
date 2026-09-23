import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 用户身份二维码页面（My QR）。
///
/// 展示用户名 + 二维码 + 提示文案，点击「Download QR」通过 [RepaintBoundary]
/// 截图并用 [ImageGallerySaverPlus] 保存到相册。
class MyQrScreen extends ConsumerStatefulWidget {
  const MyQrScreen({super.key});

  @override
  ConsumerState<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends ConsumerState<MyQrScreen> {
  static const _hintText = 'Merchant scans this QR\nto award points to user.';

  final GlobalKey _captureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).fetchIfNeeded();
    });
  }

  Future<void> _downloadQr() async {
    await EasyLoading.show();
    try {
      final boundary = _captureKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        ToastUtil.showError('Failed to save QR code');
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        ToastUtil.showError('Failed to save QR code');
        return;
      }

      final bytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: 'my_qr_${DateTime.now().millisecondsSinceEpoch}',
      );

      final isSuccess = result is Map && result['isSuccess'] == true;
      if (isSuccess) {
        ToastUtil.showSuccess('Saved to gallery');
      } else {
        ToastUtil.showError('Failed to save QR code');
      }
    } catch (_) {
      ToastUtil.showError('Failed to save QR code');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).value;
    final qrCode = profile?.qrCode ?? '';
    final displayName = profile?.fullName ?? '';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'My QR',
            style: TextStyle(
              fontFamily: 'FD',
              fontSize: 20,
              color: Colors.black,
              fontVariations: [FontVariation('wght', 500)],
            ),
          ),
        ),
        body: qrCode.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: RepaintBoundary(
                        key: _captureKey,
                        child: ColoredBox(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildQrCard(qrCode, displayName),
                              const SizedBox(height: 24),
                              const Text(
                                _hintText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'HG',
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontVariations: [FontVariation('wght', 400)],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildDownloadButton(context),
                ],
              ),
      ),
    );
  }

  Widget _buildQrCard(String qrCode, String displayName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: qrCode,
            size: 220,
            backgroundColor: Colors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.M,
          ),
          const SizedBox(height: 20),
          Text(
            displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'HG',
              fontSize: 16,
              color: Colors.black,
              fontVariations: [FontVariation('wght', 500)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _downloadQr,
          style: ElevatedButton.styleFrom(
            backgroundColor: brandBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Download QR',
            style: TextStyle(
              fontFamily: 'HG',
              fontSize: 16,
              color: Colors.white,
              fontVariations: [FontVariation('wght', 500)],
            ),
          ),
        ),
      ),
    );
  }
}
