import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/settlement/settlement_assets.dart';
import 'package:neast/features/settlement/settlement_constants.dart';

/// How Neast Charges You 说明卡片。
class SettlementHowChargesCard extends StatelessWidget {
  const SettlementHowChargesCard({super.key});

  static const _aspectRatio = 343 / 80;
  static const _itemGap = 8.0;
  static const _rowHeight = 12.0;
  static const _dotSize = 8.0;
  static const _railWidth = 8.0;

  static const _textStyle = TextStyle(
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final textColor = brandBlue.withValues(alpha: 0.72);
    final lineColor = brandBlue.withValues(alpha: 0.18);
    final dotBorderColor = brandBlue.withValues(alpha: 0.35);
    final items = SettlementConstants.howChargesItems;
    final contentHeight =
        items.length * _rowHeight + (items.length - 1) * _itemGap;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                SettlementAssets.howCharges,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 72, 0),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomPaint(
                        size: Size(_railWidth, contentHeight),
                        painter: _TimelineRailPainter(
                          itemCount: items.length,
                          rowHeight: _rowHeight,
                          itemGap: _itemGap,
                          dotSize: _dotSize,
                          lineColor: lineColor,
                          dotBorderColor: dotBorderColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < items.length; i++) ...[
                              if (i > 0) const SizedBox(height: _itemGap),
                              SizedBox(
                                height: _rowHeight,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    items[i],
                                    style: _textStyle.copyWith(
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineRailPainter extends CustomPainter {
  const _TimelineRailPainter({
    required this.itemCount,
    required this.rowHeight,
    required this.itemGap,
    required this.dotSize,
    required this.lineColor,
    required this.dotBorderColor,
  });

  final int itemCount;
  final double rowHeight;
  final double itemGap;
  final double dotSize;
  final Color lineColor;
  final Color dotBorderColor;

  double _dotCenterY(int index) {
    return rowHeight / 2 + index * (rowHeight + itemGap);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final dotRadius = dotSize / 2;
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (var i = 0; i < itemCount; i++) {
      final centerY = _dotCenterY(i);

      if (i < itemCount - 1) {
        final nextCenterY = _dotCenterY(i + 1);
        canvas.drawLine(
          Offset(centerX, centerY + dotRadius),
          Offset(centerX, nextCenterY - dotRadius),
          linePaint,
        );
      }

      final dotPaint = Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(centerX, centerY), dotRadius, dotPaint);

      final borderPaint = Paint()
        ..color = dotBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(Offset(centerX, centerY), dotRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TimelineRailPainter oldDelegate) {
    return itemCount != oldDelegate.itemCount ||
        rowHeight != oldDelegate.rowHeight ||
        itemGap != oldDelegate.itemGap ||
        dotSize != oldDelegate.dotSize ||
        lineColor != oldDelegate.lineColor ||
        dotBorderColor != oldDelegate.dotBorderColor;
  }
}
