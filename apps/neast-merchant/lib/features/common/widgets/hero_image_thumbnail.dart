import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// 可点击的网络图片缩略图，内置 Hero 共享元素动画 + 全屏预览。
///
/// 点击后打开全屏查看（带 Hero 飞入飞出、拖动退出、背景渐显）。
class HeroImageThumbnail extends StatelessWidget {
  const HeroImageThumbnail({
    super.key,
    required this.heroTag,
    required this.imageUrl,
    this.width,
    this.height = 110,
    this.borderRadius = 6.0,
    this.showCloseButton = false,
  });

  /// 与预览页 Hero 配对的唯一标识。
  final Object heroTag;

  /// 网络图片地址。
  final String imageUrl;

  /// 缩略图宽度；不传则占满父级宽度。
  final double? width;

  /// 缩略图高度，默认 110。
  final double height;

  /// 圆角半径，默认 6。
  final double borderRadius;

  /// 预览页是否显示右上角关闭按钮，默认 false（支持单击/拖动退出）。
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openImagePreview(
        context,
        heroTag: heroTag,
        imageUrl: imageUrl,
        showCloseButton: showCloseButton,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Hero(
          tag: heroTag,
          placeholderBuilder: (_, heroSize, __) => SizedBox(
            width: width ?? heroSize.width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Material(
                type: MaterialType.transparency,
                child: _buildImage(),
              ),
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: _buildImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (_, __) => Container(
        height: height,
        width: width ?? double.infinity,
        color: const Color(0xFFEFEFEF),
      ),
      errorWidget: (_, __, ___) => Container(
        height: height,
        width: width ?? double.infinity,
        color: const Color(0xFFEFEFEF),
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          size: 28,
          color: Colors.black.withValues(alpha: 0.22),
        ),
      ),
    );
  }
}

const Duration _kRouteDuration = Duration(milliseconds: 350);

void _openImagePreview(
  BuildContext context, {
  required Object heroTag,
  required String imageUrl,
  bool showCloseButton = false,
}) {
  Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      transitionDuration: _kRouteDuration,
      reverseTransitionDuration: _kRouteDuration,
      pageBuilder: (context, animation, _) => _ImagePreviewPage(
        imageUrl: imageUrl,
        heroTag: heroTag,
        barrierAnimation: animation,
        showCloseButton: showCloseButton,
      ),
      transitionsBuilder: (_, __, ___, child) => child,
    ),
  );
}

class _ImagePreviewPage extends StatefulWidget {
  const _ImagePreviewPage({
    required this.imageUrl,
    required this.heroTag,
    required this.barrierAnimation,
    this.showCloseButton = false,
  });

  final String imageUrl;
  final Object heroTag;
  final Animation<double> barrierAnimation;
  final bool showCloseButton;

  @override
  State<_ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<_ImagePreviewPage>
    with TickerProviderStateMixin {
  static const double _kMaxDragTransparency = 0.7;
  static const double _kMinPullScale = 0.7;
  static const double _kScaleRange = 1.0 - _kMinPullScale;
  static const double _kDistForMinScale = 320;
  static const double _kDismissDragDist = 120;
  static const double _kDismissVelocity = 800;
  static const double _kDimByDragRef = 320;

  late final PhotoViewController _controller;
  late final PhotoViewScaleStateController _scaleStateController;
  late final AnimationController _pullResetController;
  late final ValueNotifier<Offset> _pullOffset;
  late final Listenable _scrimListenable;
  StreamSubscription<PhotoViewScaleState>? _scaleSub;

  int _pointerCount = 0;
  Offset _pullResetBegin = Offset.zero;
  Offset _dragVelocity = Offset.zero;
  DateTime? _lastMoveTime;
  Offset? _lastMovePos;

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController();
    _scaleStateController = PhotoViewScaleStateController();
    _pullOffset = ValueNotifier(Offset.zero);

    _scaleSub = _scaleStateController.outputScaleStateStream.listen((_) {
      if (!mounted) return;
      if (_scaleStateController.scaleState != PhotoViewScaleState.initial &&
          _pullOffset.value != Offset.zero) {
        _pullOffset.value = Offset.zero;
      }
    });

    _pullResetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(_onPullResetTick);

    _scrimListenable = Listenable.merge([
      widget.barrierAnimation,
      _pullOffset,
    ]);
  }

  void _onPullResetTick() {
    final t = Curves.easeOut.transform(_pullResetController.value);
    _pullOffset.value = Offset.lerp(_pullResetBegin, Offset.zero, t)!;
  }

  @override
  void dispose() {
    _scaleSub?.cancel();
    _scaleStateController.dispose();
    _controller.dispose();
    _pullResetController.dispose();
    _pullOffset.dispose();
    super.dispose();
  }

  bool get _atInitialZoom =>
      _scaleStateController.scaleState == PhotoViewScaleState.initial;

  double get _pullVisualScale {
    if (!_atInitialZoom) return 1.0;
    final u = (_pullOffset.value.distance / _kDistForMinScale).clamp(0.0, 1.0);
    return 1.0 - u * _kScaleRange;
  }

  double _easedDimT() {
    final raw = widget.barrierAnimation.value.clamp(0.0, 1.0);
    return const Interval(0.22, 1.0, curve: Curves.easeOut).transform(raw);
  }

  double _scrimOpacity(double routeDimT) {
    final dragProgress =
        (_pullOffset.value.distance / _kDimByDragRef).clamp(0.0, 1.0);
    final opacityFromDrag = 1.0 - _kMaxDragTransparency * dragProgress;
    return (routeDimT * opacityFromDrag).clamp(0.0, 1.0);
  }

  void _onPointerDown(PointerDownEvent e) {
    _pullResetController.stop();
    _pointerCount++;
    if (_pointerCount > 1) _pullOffset.value = Offset.zero;
    _lastMoveTime = DateTime.now();
    _lastMovePos = e.position;
    _dragVelocity = Offset.zero;
  }

  void _onPointerUpOrCancel() {
    _pointerCount = (_pointerCount - 1).clamp(0, 8);
    _lastMoveTime = null;
    _lastMovePos = null;
    if (_pointerCount == 0) _finishPullDismissGesture();
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (!_atInitialZoom || _pointerCount != 1) return;
    final now = DateTime.now();
    if (_lastMoveTime != null && _lastMovePos != null) {
      final dt = now.difference(_lastMoveTime!).inMicroseconds / 1e6;
      if (dt > 1e-6) {
        _dragVelocity = Offset(
          (e.position.dx - _lastMovePos!.dx) / dt,
          (e.position.dy - _lastMovePos!.dy) / dt,
        );
      }
    }
    _lastMoveTime = now;
    _lastMovePos = e.position;
    _pullOffset.value = _pullOffset.value + e.delta;
  }

  void _finishPullDismissGesture() {
    if (!_atInitialZoom) {
      if (_pullOffset.value != Offset.zero) {
        _pullOffset.value = Offset.zero;
      }
      return;
    }
    final dist = _pullOffset.value.dy.abs();
    final v = _dragVelocity.distance;
    final shouldPop = dist >= _kDismissDragDist || v >= _kDismissVelocity;
    if (!mounted) return;
    if (shouldPop) {
      Navigator.of(context).maybePop();
      return;
    }
    if (dist < 0.5) return;
    _pullResetBegin = _pullOffset.value;
    _pullResetController.forward(from: 0);
  }

  void _onTapClose(BuildContext context) {
    if (!context.mounted) return;
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _scrimListenable,
          builder: (context, _) {
            return ColoredBox(
              color: Colors.black.withValues(alpha: _scrimOpacity(_easedDimT())),
            );
          },
        ),
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _onPointerDown,
          onPointerUp: (_) => _onPointerUpOrCancel(),
          onPointerCancel: (_) => _onPointerUpOrCancel(),
          onPointerMove: _onPointerMove,
          child: AnimatedBuilder(
            animation: _pullOffset,
            builder: (context, child) {
              return Transform.translate(
                offset: _atInitialZoom ? _pullOffset.value : Offset.zero,
                child: Transform.scale(
                  scale: _atInitialZoom ? _pullVisualScale : 1.0,
                  alignment: Alignment.center,
                  child: child,
                ),
              );
            },
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(widget.imageUrl),
              controller: _controller,
              scaleStateController: _scaleStateController,
              heroAttributes: PhotoViewHeroAttributes(
                tag: widget.heroTag,
                transitionOnUserGestures: true,
              ),
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              initialScale: PhotoViewComputedScale.contained,
              onTapUp: (context, _, __) => _onTapClose(context),
              loadingBuilder: (context, event) {
                final total = event?.expectedTotalBytes;
                final loaded = event?.cumulativeBytesLoaded;
                return Center(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white54,
                      value: (total != null && total > 0 && loaded != null)
                          ? loaded / total
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white38,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
        if (widget.showCloseButton)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
      ],
    );
  }
}
