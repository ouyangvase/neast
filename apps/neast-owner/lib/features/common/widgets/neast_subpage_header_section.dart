import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// 子页面通用顶栏样式常量。
abstract final class NeastSubpageHeaderStyles {
  static const backgroundAsset = 'assets/images/app_header.png';
  static const defaultFillColor = Color(0xFFF2F9FC);
  static const imageAspectRatio = 635 / 1500;
  static const defaultHeaderOverlap = 43.0;
  static const defaultHorizontalPadding = 16.0;
  static const toolbarPadding = EdgeInsets.fromLTRB(4, 0, 16, 0);
  static const backIconSize = 23.0;
  static const subtitleFontSize = 10.0;
  static const titleFontSize = 18.0;
  static const subtitleTitleGap = 4.0;

  static const titleStyle = TextStyle(
    fontFamily: 'FD',
    fontSize: titleFontSize,
    color: Colors.white,
    fontVariations: [FontVariation('wght', 500)],
    height: 1.1,
  );
}

/// 子页面通用顶栏：app_header 背景 + 返回 + 副标题/主标题。
class NeastSubpageHeaderSection extends StatelessWidget {
  const NeastSubpageHeaderSection({
    super.key,
    required this.title,
    this.subtitle = '',
    this.fillColor = NeastSubpageHeaderStyles.defaultFillColor,
    this.backgroundAsset = NeastSubpageHeaderStyles.backgroundAsset,
    this.onBack,
  });

  final String subtitle;
  final String title;
  final Color fillColor;
  final String backgroundAsset;
  final VoidCallback? onBack;

  static double imageHeightOf(BuildContext context) {
    return MediaQuery.sizeOf(context).width *
        NeastSubpageHeaderStyles.imageAspectRatio;
  }

  static double cardTopOf(
    BuildContext context, {
    double headerOverlap = NeastSubpageHeaderStyles.defaultHeaderOverlap,
  }) {
    return imageHeightOf(context) - headerOverlap;
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = imageHeightOf(context);

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: _NeastSubpageHeaderBackground(
              fillColor: fillColor,
              backgroundAsset: backgroundAsset,
            ),
          ),
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: _NeastSubpageHeaderToolbar(
              subtitle: subtitle,
              title: title,
              onBack: onBack ?? () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 顶栏 + 上叠内容。
class NeastSubpageHeaderOverlapLayout extends StatelessWidget {
  const NeastSubpageHeaderOverlapLayout({
    super.key,
    required this.title,
    required this.overlapChild,
    this.subtitle = '',
    this.fillColor = NeastSubpageHeaderStyles.defaultFillColor,
    this.headerOverlap = NeastSubpageHeaderStyles.defaultHeaderOverlap,
    this.horizontalPadding = NeastSubpageHeaderStyles.defaultHorizontalPadding,
    this.backgroundAsset = NeastSubpageHeaderStyles.backgroundAsset,
    this.onBack,
  });

  final String subtitle;
  final String title;
  final Widget overlapChild;
  final Color fillColor;
  final double headerOverlap;
  final double horizontalPadding;
  final String backgroundAsset;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NeastSubpageHeaderSection(
            subtitle: subtitle,
            title: title,
            fillColor: fillColor,
            backgroundAsset: backgroundAsset,
            onBack: onBack,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            NeastSubpageHeaderSection.cardTopOf(
              context,
              headerOverlap: headerOverlap,
            ),
            horizontalPadding,
            0,
          ),
          child: overlapChild,
        ),
      ],
    );
  }
}

class _NeastSubpageHeaderBackground extends StatelessWidget {
  const _NeastSubpageHeaderBackground({
    required this.fillColor,
    required this.backgroundAsset,
  });

  final Color fillColor;
  final String backgroundAsset;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: fillColor,
        child: Image.asset(
          backgroundAsset,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}

class _NeastSubpageHeaderToolbar extends StatelessWidget {
  const _NeastSubpageHeaderToolbar({
    required this.subtitle,
    required this.title,
    required this.onBack,
  });

  final String subtitle;
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: NeastSubpageHeaderStyles.toolbarPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: NeastSubpageHeaderStyles.backIconSize,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (subtitle.isNotEmpty) ...[
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: NeastSubpageHeaderStyles.subtitleFontSize,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(
                      height: NeastSubpageHeaderStyles.subtitleTitleGap,
                    ),
                  ],
                  Text(
                    title,
                    style: NeastSubpageHeaderStyles.titleStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
