import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/common/widgets/hero_image_thumbnail.dart';
import 'package:neast/features/give_points/give_points_constants.dart';
import 'package:neast/features/give_points/models/receipt_capture_result.dart';

/// Header 上叠：凭证缩略图 + 文件信息 + Retake。
class ReceiptPreviewOverlapCard extends StatelessWidget {
  const ReceiptPreviewOverlapCard({
    super.key,
    required this.capture,
    required this.onRetake,
  });

  final ReceiptCaptureResult capture;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          HeroImageThumbnail(
            heroTag: Object.hash(
              GivePointsConstants.receiptImageHeroTag,
              capture.imageUrl,
            ),
            imageUrl: capture.imageUrl,
            width: 48,
            height: 48,
            borderRadius: 8,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capture.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${capture.formattedFileSize} · Captured Just Now',
                  style: TextStyle(
                    fontSize: 11,
                    color: brandBlue.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRetake,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                'Retake',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: brandBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
