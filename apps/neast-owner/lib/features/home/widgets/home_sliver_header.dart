import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';

/// 首页折叠头部：展开显示完整资料，滚动后收起为品牌蓝纯色栏（仅 Hi + 消息按钮）。
///
/// 使用 [SliverAppBar] + [FlexibleSpaceBar.collapseMode] = pin，
/// 与用户端 Refer 页同一套可靠方案，避免 [SliverPersistentHeader] 的裁剪/高度偏差。
class HomeSliverHeader extends ConsumerWidget {
  const HomeSliverHeader({
    super.key,
    required this.collapseProgress,
    this.collected = 'RM -',
    this.collectionRateText = '0% Collection Rate',
    this.overdueAmountText = 'RM 0 Overdue',
    this.hasUnreadMessage = false,
    this.onMessage,
  });

  /// 0 = 完全展开，1 = 完全折叠。
  final double collapseProgress;
  final String collected;
  final String collectionRateText;
  final String overdueAmountText;
  final bool hasUnreadMessage;
  final VoidCallback? onMessage;

  static const _backgroundAspectWidth = 375.0;
  static const _backgroundAspectHeight = 180.0;

  static double imageHeightOf(BuildContext context) {
    return MediaQuery.sizeOf(context).width *
        _backgroundAspectHeight /
        _backgroundAspectWidth;
  }

  /// [SliverAppBar.expandedHeight]（不含状态栏，[SliverAppBar.primary] 会自动处理）。
  static double expandedHeightOf(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    return imageHeightOf(context) - topPadding;
  }

  static double collapseDistanceOf(BuildContext context) {
    return (expandedHeightOf(context) - kToolbarHeight).clamp(1.0, double.infinity);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final landlordInfo = ref.watch(landlordInfoProvider).value;
    final topPadding = MediaQuery.paddingOf(context).top;
    final brandBlue = context.appColors.brandBlue;
    final t = collapseProgress.clamp(0.0, 1.0);
    final expandedContentOpacity = (1 - t * 1.5).clamp(0.0, 1.0);
    final collapsedTitleOpacity = ((t - 0.45) * 2.2).clamp(0.0, 1.0);
    final showToolbarMessage = t > 0.35;
    final showFlexibleMessage = !showToolbarMessage;

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeightOf(context),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: brandBlue,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: kToolbarHeight,
      actions: showToolbarMessage
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 4, top: 4),
                child: _MessageButton(
                  onTap: onMessage,
                  showBadge: hasUnreadMessage,
                ),
              ),
            ]
          : null,
      title: collapsedTitleOpacity > 0
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Opacity(
                opacity: collapsedTitleOpacity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hi, ${landlordInfo?.name ?? '-'}',
                    style: const TextStyle(
                      fontFamily: 'FD',
                      fontSize: 15,
                      fontVariations: [FontVariation('wght', 500)],
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            const ColoredBox(color: HomeColors.background),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                HomeAssets.headerBg,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            ColoredBox(color: brandBlue.withValues(alpha: t)),
            if (expandedContentOpacity > 0)
              Opacity(
                opacity: expandedContentOpacity,
                child: _ExpandedContent(
                  topPadding: topPadding,
                  greeting: landlordInfo?.name ?? '-',
                  collected: collected,
                  collectionRateText: collectionRateText,
                  overdueAmountText: overdueAmountText,
                ),
              ),
            Positioned(
              top: topPadding + 6,
              right: 12,
              child: IgnorePointer(
                ignoring: !showFlexibleMessage,
                child: Opacity(
                  opacity: showFlexibleMessage ? 1 : 0,
                  child: _MessageButton(
                    onTap: onMessage,
                    showBadge: hasUnreadMessage,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  const _ExpandedContent({
    required this.topPadding,
    required this.greeting,
    required this.collected,
    required this.collectionRateText,
    required this.overdueAmountText,
  });

  final double topPadding;
  final String greeting;
  final String collected;
  final String collectionRateText;
  final String overdueAmountText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, $greeting',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 500)],
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            'Collected This Month',
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            collected,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 500)],
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _HeaderPill(
                text: collectionRateText,
                color: const Color(0xFF2E6FB5),
              ),
              const SizedBox(width: 8),
              _HeaderPill(
                text: overdueAmountText,
                color: HomeColors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontFamily: 'HG',
          fontVariations: [FontVariation('wght', 400)],
          color: Colors.white,
        ),
      ),
    );
  }
}

class _MessageButton extends StatelessWidget {
  const _MessageButton({
    this.onTap,
    this.showBadge = false,
  });

  final VoidCallback? onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, top: 20),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Image.asset(HomeAssets.msgIcon, width: 24, height: 24),
            if (showBadge)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5631E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
