import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/home/models/home_dashboard_model.dart';
import 'package:neast/features/home/providers/home_dashboard_provider.dart';

/// 首页促销横幅轮播，支持左右滑动切换及圆点指示器。
class PromoCarousel extends ConsumerStatefulWidget {
  const PromoCarousel({super.key});

  static const _placeholderColor = Color(0xFFE8ECF0);

  @override
  ConsumerState<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends ConsumerState<PromoCarousel> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(homeDashboardProvider);

    final banners = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard.banners,
      orElse: () => null,
    );

    if (banners == null || banners.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_currentPage >= banners.length) {
      _currentPage = 0;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 120,
        child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _BannerImage(banner: banner),
                ),
              );
            },
          ),
          if (banners.length > 1)
            Positioned(
              right: 16,
              bottom: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(banners.length, (index) {
                  final isActive = index == _currentPage;
                  return Container(
                    width: isActive ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
        ),
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.banner});

  final HomeBannerModel banner;

  @override
  Widget build(BuildContext context) {
    final imageUrl = banner.imageUrl;
    if (imageUrl.isEmpty) {
      return const ColoredBox(
        color: PromoCarousel._placeholderColor,
        child: SizedBox.expand(),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (_, __) => const ColoredBox(
        color: PromoCarousel._placeholderColor,
        child: SizedBox.expand(),
      ),
      errorWidget: (_, __, ___) => const ColoredBox(
        color: PromoCarousel._placeholderColor,
        child: SizedBox.expand(),
      ),
    );
  }
}
