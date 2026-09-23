import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/properties/models/property_model.dart';
import 'package:neast_landlords/features/properties/utils/property_file_actions.dart';

/// 物业列表卡片。
class PropertyListCard extends StatelessWidget {
  const PropertyListCard({
    super.key,
    required this.item,
    this.onDocumentTap,
    this.onQrcodeTap,
  });

  final PropertyModel item;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onQrcodeTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final imageUrl = resolvePropertyImageUrl(item);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 56,
                      height: 56,
                      color: const Color(0xFFE8F0F8),
                      child: const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Image.asset(
                      HomeAssets.houseEg,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    HomeAssets.houseEg,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: HomeColors.label,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        item.address,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 400)],
                          color: HomeColors.label,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (onQrcodeTap != null) ...[
            GestureDetector(
              onTap: onQrcodeTap,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.qr_code_2,
                size: 22,
                color: brandBlue.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: onDocumentTap,
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              HomeAssets.agreementCircle,
              width: 22,
              height: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/// 表单内已选照片预览。
class PropertyPhotoPreview extends StatelessWidget {
  const PropertyPhotoPreview({
    super.key,
    required this.file,
  });

  final File file;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        file,
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      ),
    );
  }
}
