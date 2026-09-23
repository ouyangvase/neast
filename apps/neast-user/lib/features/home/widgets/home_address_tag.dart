import 'package:flutter/material.dart';

/// 商家卡片地址标签，过长时在限定宽度内横向滚动展示。
class HomeAddressTag extends StatelessWidget {
  const HomeAddressTag({
    super.key,
    required this.address,
    required this.maxWidth,
    this.textStyle = const TextStyle(
      fontSize: 4.5,
      color: Colors.white,
      height: 1.2,
    ),
    this.iconSize = 8,
    this.horizontalPadding = 5,
    this.verticalPadding = 4,
    this.borderRadius = 15,
    this.backgroundOpacity = 0.6,
  });

  final String address;
  final double maxWidth;
  final TextStyle textStyle;
  final double iconSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: backgroundOpacity),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: iconSize,
              color: Colors.white,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textWidth = _measureTextWidth(address, textStyle);
                  if (textWidth <= constraints.maxWidth) {
                    return Text(
                      address,
                      maxLines: 1,
                      style: textStyle,
                    );
                  }

                  return _MarqueeAddressText(
                    text: address,
                    width: constraints.maxWidth,
                    textStyle: textStyle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static double _measureTextWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}

class _MarqueeAddressText extends StatefulWidget {
  const _MarqueeAddressText({
    required this.text,
    required this.width,
    required this.textStyle,
  });

  final String text;
  final double width;
  final TextStyle textStyle;

  @override
  State<_MarqueeAddressText> createState() => _MarqueeAddressTextState();
}

class _MarqueeAddressTextState extends State<_MarqueeAddressText>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
  }

  @override
  void didUpdateWidget(_MarqueeAddressText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.width != widget.width ||
        oldWidget.textStyle != widget.textStyle) {
      _stopMarquee();
      WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
    }
  }

  void _startMarquee() {
    if (!mounted || !_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200 + (maxScroll * 25).round()),
    );

    void onStatus(AnimationStatus status) {
      if (!mounted) return;
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _animationController?.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _animationController?.forward();
        });
      }
    }

    _animationController!
      ..addListener(() {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_animationController!.value * maxScroll);
        }
      })
      ..addStatusListener(onStatus)
      ..forward();
  }

  void _stopMarquee() {
    _animationController?.dispose();
    _animationController = null;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _stopMarquee();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lineHeight =
        (widget.textStyle.fontSize ?? 12) * (widget.textStyle.height ?? 1.2);

    return SizedBox(
      width: widget.width,
      height: lineHeight,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(
          widget.text,
          maxLines: 1,
          style: widget.textStyle,
        ),
      ),
    );
  }
}
