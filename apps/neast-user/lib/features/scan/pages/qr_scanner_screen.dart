import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';

/// 全屏扫码页，扫码成功返回内容字符串。
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  final ImagePicker _imagePicker = ImagePicker();

  late final AnimationController _scanLineController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  bool _handled = false;
  bool _pickingGallery = false;
  bool _closing = false;

  @override
  void dispose() {
    _scanLineController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _close() => _finish(null);

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final value = _extractRawValue(capture);
    if (value == null || value.isEmpty) return;
    _finish(value);
  }

  /// 先移除相机纹理并停流，待黑色占位渲染一帧后再返回，避免退出动画末尾纹理闪烁。
  Future<void> _finish(String? value) async {
    if (_handled || !mounted) return;
    _handled = true;
    setState(() => _closing = true);
    await WidgetsBinding.instance.endOfFrame;
    await _controller.stop();
    if (!mounted) return;
    Navigator.of(context).pop(value);
  }

  String? _extractRawValue(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue?.trim();
      if (rawValue != null && rawValue.isNotEmpty) {
        return rawValue;
      }
    }
    return null;
  }

  Future<void> _pickFromGallery() async {
    if (_handled || _pickingGallery) {
      return;
    }

    setState(() => _pickingGallery = true);
    try {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (!mounted || picked == null) {
        return;
      }

      final capture = await _controller.analyzeImage(picked.path);
      if (!mounted) {
        return;
      }

      final value = capture == null ? null : _extractRawValue(capture);
      if (value == null || value.isEmpty) {
        ToastUtil.showError('No QR code found in the selected image.');
        return;
      }

      await _finish(value);
    } catch (_) {
      if (mounted) {
        ToastUtil.showError('Failed to read QR code from gallery.');
      }
    } finally {
      if (mounted) {
        setState(() => _pickingGallery = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!_closing)
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              fit: BoxFit.cover,
            ),
          IgnorePointer(
            child: Center(
              child: _ScanFrameOverlay(animation: _scanLineController),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _close,
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          'Scan QR Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: GestureDetector(
                    onTap: _pickingGallery ? null : _pickFromGallery,
                    behavior: HitTestBehavior.opaque,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: brandBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_pickingGallery)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else
                              const Icon(
                                Icons.photo_library_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            const SizedBox(width: 8),
                            const Text(
                              'Choose from gallery',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 扫码框：四角青色边框 + 上下移动的发光扫描线。
class _ScanFrameOverlay extends StatelessWidget {
  const _ScanFrameOverlay({required this.animation});

  final Animation<double> animation;

  static const Color _accent = Color(0xFF2BC0F5);
  static const double _cornerLength = 28;
  static const double _cornerWidth = 4;

  @override
  Widget build(BuildContext context) {
    final side = MediaQuery.sizeOf(context).width - 80;

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        children: [
          _corner(top: true, left: true),
          _corner(top: true, left: false),
          _corner(top: false, left: true),
          _corner(top: false, left: false),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Positioned(
                left: 6,
                right: 6,
                top: animation.value * (side - 2),
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x002BC0F5),
                        _accent,
                        Color(0x002BC0F5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _accent,
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _corner({required bool top, required bool left}) {
    const border = BorderSide(color: _accent, width: _cornerWidth);
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
