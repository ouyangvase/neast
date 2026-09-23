import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// 商户详情页顶部图片资源。
abstract final class MerchantDetailAssets {
  static const headerBg = 'assets/images/merchant/header-bg.png';
}

/// 商户详情页顶部 Hero 区域（兑换详情 / 商家二维码等页面共用）。
class MerchantDetailHero extends StatelessWidget {
  const MerchantDetailHero({
    super.key,
    this.height = 200,
    this.imageUrl = '',
    this.onShareTap,
  });

  final double height;
  final String imageUrl;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: onShareTap,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB9CFEA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.share,
                          size: 16,
                          color: Color(0xFF4574BD),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        placeholder: (_, __) => _defaultBackground(),
        errorWidget: (_, __, ___) => _defaultBackground(),
      );
    }

    return _defaultBackground();
  }

  Widget _defaultBackground() {
    return Image.asset(
      MerchantDetailAssets.headerBg,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
    );
  }
}
