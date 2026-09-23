import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 优惠券详情页 Hero 图。
class CouponDetailHero extends StatelessWidget {
  const CouponDetailHero({
    super.key,
    required this.imageUrl,
  });

  static const heroRadius = 12.0;
  static const aspectRatio = 343 / 150;

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(heroRadius),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => ColoredBox(color: brandBlueLight),
                  errorWidget: (_, __, ___) => ColoredBox(color: brandBlueLight),
                )
              : ColoredBox(
                  color: brandBlueLight,
                  child: Center(
                    child: Icon(
                      Icons.local_offer_outlined,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
