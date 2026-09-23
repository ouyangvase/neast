import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/give_points/give_points_assets.dart';
import 'package:neast/features/give_points/utils/receipt_capture_flow.dart';

/// 小票上传卡片。
class GivePointsReceiptCard extends ConsumerWidget {
  const GivePointsReceiptCard({super.key});

  static const _borderRadius = 16.0;
  static const _borderWidth = 2.0;

  static const _borderGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFEBF4FD),
      Color(0xFF79ADDE),
    ],
  );

  static const _scanButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDB9029),
      Color(0xFFECC39E),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        gradient: _borderGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(_borderWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_borderRadius - _borderWidth),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 59, 20, 41),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => showReceiptCaptureOptions(context, ref),
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    GivePointsAssets.camera,
                    width: 60,
                    height: 54,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Snap or upload receipt',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 44),
                GestureDetector(
                  onTap: () => startReceiptDocumentScan(context, ref),
                  behavior: HitTestBehavior.opaque,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: _scanButtonGradient,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      child: Text(
                        'Scan with camera',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
