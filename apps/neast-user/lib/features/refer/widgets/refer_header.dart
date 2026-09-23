import 'package:flutter/material.dart';
import 'package:neast/features/refer/widgets/refer_stats_card.dart';

/// 推荐页顶部区域常量与 [SliverAppBar.flexibleSpace] 背景。
class ReferHeader {
  ReferHeader._();

  /// 内容区背景色，顶图下方未被顶图覆盖的区域使用该色。
  static const contentBackground = Color(0xFFF6F9F6);

  /// 顶图原始尺寸 1500x635，宽度撑满时按该比例渲染（约 150 高）。
  static const double _imageAspectRatio = 635 / 1500;

  /// 统计卡片相对顶图底部向下伸出的高度，使其跨在顶图与内容区之间。
  static const double _statsCardDrop = 36.0;

  /// [SliverAppBar.expandedHeight]（不含状态栏，[SliverAppBar.primary] 会自动处理）。
  ///
  /// 顶图自屏幕顶部（状态栏下方）按原始比例铺满宽度，展开高度需扣除状态栏，
  /// 并额外预留 [_statsCardDrop] 让统计卡片向下伸入内容区。
  static double expandedHeight(BuildContext context) {
    final media = MediaQuery.of(context);
    final imageHeight = media.size.width * _imageAspectRatio;
    return imageHeight - media.padding.top + _statsCardDrop;
  }

  /// 供 [SliverAppBar.flexibleSpace] 使用的顶图背景 + 统计卡片叠层。
  static Widget flexibleSpace() {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // 顶图：白底承接其底部透明缺口，缺口呈白色（替代原圆角过渡条）。
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFFFFFFFF),
              child: Image.asset(
                'assets/images/points/header-bg.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          // 统计卡片：跨在顶图底部缺口与内容区之间。
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ReferStatsCard(),
          ),
        ],
      ),
    );
  }
}
