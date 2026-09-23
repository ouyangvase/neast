import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Tent Score 半圆仪表盘。
///
/// 支持从 [fromScore] 过渡到 [toScore]；[animate] 为 false 时直接展示目标值。
class TentScoreGauge extends StatefulWidget {
  const TentScoreGauge({
    super.key,
    required this.fromScore,
    required this.toScore,
    required this.maxScore,
    required this.ratingLabel,
    required this.animate,
    this.duration = const Duration(milliseconds: 1200),
  });

  final int fromScore;
  final int toScore;
  final int maxScore;
  final String ratingLabel;
  final bool animate;
  final Duration duration;

  static const _startAngle = 180.0;
  static const _sweepAngle = 180.0;
  static const _strokeWidth = 8.0;
  static const _scoreGreen = Color(0xFF008823);

  @override
  State<TentScoreGauge> createState() => _TentScoreGaugeState();
}

class _TentScoreGaugeState extends State<TentScoreGauge>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  @override
  void didUpdateWidget(TentScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fromScore != widget.fromScore ||
        oldWidget.toScore != widget.toScore ||
        oldWidget.animate != widget.animate) {
      _controller?.dispose();
      _setupAnimation();
    }
  }

  void _setupAnimation() {
    if (!widget.animate || widget.fromScore == widget.toScore) {
      _controller = null;
      _animation = null;
      return;
    }

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOutCubic,
    );
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  double get _progressValue {
    if (widget.maxScore <= 0) return 0;
    final score = _displayScore;
    return (score / widget.maxScore).clamp(0.0, 1.0);
  }

  int get _displayScore {
    if (!widget.animate || _animation == null) {
      return widget.toScore;
    }
    final t = _animation!.value;
    return widget.fromScore + ((widget.toScore - widget.fromScore) * t).round();
  }

  @override
  Widget build(BuildContext context) {
    if (_animation != null) {
      return AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) => _buildGauge(),
      );
    }

    return _buildGauge();
  }

  Widget _buildGauge() {
    return AspectRatio(
      aspectRatio: 2,
      child: CustomPaint(
        painter: _GaugePainter(
          progress: _progressValue,
          activeColor: TentScoreGauge._scoreGreen,
          trackColor: const Color(0xFFE5E7EB),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_displayScore',
                style: const TextStyle(
                  fontSize: 46,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 800)],
                  color: Color(0xFF0F172A),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.ratingLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 600)],
                  color: TentScoreGauge._scoreGreen,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'out of ${widget.maxScore}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'HG',
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  final double progress;
  final Color activeColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = TentScoreGauge._strokeWidth;
    final inset = strokeWidth / 2 + 2;
    final radius = size.width / 2 - inset;
    final center = Offset(size.width / 2, size.height - inset);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startRad = TentScoreGauge._startAngle * math.pi / 180;
    final sweepRad = TentScoreGauge._sweepAngle * math.pi / 180;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawArc(rect, startRad, sweepRad, false, trackPaint);

    final clamped = progress.clamp(0.0, 1.0);
    if (clamped > 0) {
      final activePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = activeColor;
      canvas.drawArc(rect, startRad, sweepRad * clamped, false, activePaint);
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor;
  }
}
