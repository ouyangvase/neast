import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 项目通用下拉刷新 / 上拉加载更多组件。
///
/// 基于 [EasyRefresh] 封装，统一了 header / footer 的中文文案和视觉样式，
/// 所有需要刷新 / 加载更多的列表页面都应使用此组件，而不是直接使用 [EasyRefresh]。
///
/// 关键特性：
/// - 内置统一风格的 [ClassicHeader] / [ClassicFooter]（中文文案、绿色主题色）。
/// - 列表为空时也能下拉刷新（请确保 [child] 是可滚动的，且使用
///   [AlwaysScrollableScrollPhysics]）。
/// - [onLoad] 回调返回 `bool` 表示是否还有下一页，组件据此决定 footer 进入
///   `success` 还是 `noMore` 状态，业务侧无需手动调用 `controller.finishLoad`。
///
/// 关于 [safeArea] 的取值约定：
///
/// | 页面结构                                       | safeArea     |
/// | ---------------------------------------------- | ------------ |
/// | Scaffold + extendBodyBehindAppBar + 自定义 padding | false（默认） |
/// | Scaffold + 普通 AppBar（body 自动避让）           | false（默认） |
/// | Scaffold + CustomScrollView + SliverAppBar     | true         |
/// | 全屏无 AppBar 的沉浸式列表                       | true         |
///
/// 使用示例（Riverpod 分页 Notifier）：
///
/// ```dart
/// final controller = EasyRefreshController(
///   controlFinishRefresh: true,
///   controlFinishLoad: true,
/// );
///
/// AppRefresher(
///   controller: controller,
///   onRefresh: () => ref.read(myProvider.notifier).refresh(),
///   onLoad: () async {
///     await ref.read(myProvider.notifier).loadMore();
///     // 用 ref.read 取最新 state，避免捕获 build 时的过期值。
///     return ref.read(myProvider).hasMore;
///   },
///   child: ListView.builder(
///     physics: const AlwaysScrollableScrollPhysics(),
///     ...
///   ),
/// )
/// ```
class AppRefresher extends StatelessWidget {
  const AppRefresher({
    super.key,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.refreshOnStart = false,
    this.canRefreshAfterNoMore = true,
    this.scrollController,
    this.safeArea = false,
    this.triggerOffset = 60,
    required this.child,
  });

  /// 外部控制器。AppRefresher 内部需要主动结束刷新 / 加载，
  /// 因此当传入 [controller] 时，必须设置
  /// `controlFinishRefresh: true` 和 `controlFinishLoad: true`。
  final EasyRefreshController? controller;

  /// 下拉刷新回调。返回 [Future]，[AppRefresher] 等待其完成后自动结束动画，
  /// 并重置 footer 的 noMore 状态以便再次加载更多。
  final FutureOr<void> Function()? onRefresh;

  /// 上拉加载回调。
  ///
  /// 返回 `true` 表示还有下一页（footer 显示"加载完成"），
  /// 返回 `false` 表示已加载完所有数据（footer 显示"没有更多了"）。
  final FutureOr<bool> Function()? onLoad;

  /// 是否在首帧自动触发一次刷新。
  final bool refreshOnStart;

  /// 加载到底之后是否仍允许下拉刷新（默认允许，符合常见交互预期）。
  final bool canRefreshAfterNoMore;

  /// 透传给底部 [Scrollable] 的 controller。
  final ScrollController? scrollController;

  /// header / footer 是否额外让出 [MediaQuery] 安全区。
  ///
  /// 默认 `false`，适配本项目主流的 “Scaffold + extendBodyBehindAppBar +
  /// 自定义 padding” 结构（A 类）：EasyRefresh 的顶边已经在 AppBar 之下，
  /// 不需要再加一段状态栏高度，否则触发距离过长、指示器文案会被推到屏幕中部。
  ///
  /// 当列表挂在 SliverAppBar / CustomScrollView 等会贯穿状态栏的结构里
  /// （B 类），或挂在没有 AppBar 的全屏沉浸式页面里时，请显式传 `true`，
  /// 让下拉指示器避开状态栏、上拉指示器避开底部 home 条。
  final bool safeArea;

  /// 触发刷新 / 加载的下拉（上拉）距离，单位 px。
  ///
  /// 默认 60，比 [ClassicHeader] / [ClassicFooter] 自带的 70 略短，
  /// 更接近 iOS / Android 系统原生体验。
  final double triggerOffset;

  /// 子组件，必须是可滚动的（[ListView] / [GridView] / [CustomScrollView] /
  /// [SingleChildScrollView] 等）。为支持空状态下拉刷新，建议显式设置
  /// `physics: AlwaysScrollableScrollPhysics()`。
  final Widget child;

  // ============== 主题色 ==============
  static const Color _accent = Color(0xFF4ADE80);

  /// 项目统一 header。
  ///
  /// 注意：[ClassicHeader.safeArea] 上游默认为 `true`，会在 [triggerOffset]
  /// 之外再加上 `MediaQuery.padding.top` 的距离（iPhone 约 44~59px）。
  /// 本组件默认改为 `false`，配合主流页面避免触发距离过长、文案被推到屏幕中部。
  /// 详见 [AppRefresher.safeArea] 的文档。
  static Header buildHeader({
    bool safeArea = false,
    double triggerOffset = 60,
    required Color textColor,
  }) =>
      ClassicHeader(
        clamping: false,
        safeArea: safeArea,
        triggerOffset: triggerOffset,
        showMessage: false,
        iconTheme: const IconThemeData(color: _accent),
        textStyle: TextStyle(fontSize: 13, color: textColor),
        dragText: 'Pull down to refresh',
        armedText: 'Release to refresh',
        readyText: 'Refreshing...',
        processingText: 'Refreshing...',
        processedText: 'Refresh complete',
        noMoreText: 'No more',
        failedText: 'Refresh failed',
      );

  /// 项目统一 footer。参数语义同 [buildHeader]。
  static Footer buildFooter({
    bool safeArea = false,
    double triggerOffset = 60,
    required Color textColor,
  }) =>
      ClassicFooter(
        clamping: false,
        safeArea: safeArea,
        triggerOffset: triggerOffset,
        showMessage: false,
        // iconTheme: const IconThemeData(color: _accent),
        textStyle: TextStyle(fontSize: 13, color: textColor.withValues(alpha: 0.5)),
        dragText: 'Pull up to load',
        armedText: 'Release to load',
        readyText: 'Loading...',
        processingText: 'Loading...',
        processedText: 'Load complete',
        noMoreText: 'No more data',
        failedText: 'Load failed',

        // 消除图标
        noMoreIcon: SizedBox.shrink(),
        // iconDimension: 0,
      );

  @override
  Widget build(BuildContext context) {
    final blackText = context.appColors.blackText;
    return EasyRefresh(
      controller: controller,
      scrollController: scrollController,
      header: buildHeader(
        safeArea: safeArea,
        triggerOffset: triggerOffset,
        textColor: blackText,
      ),
      footer: buildFooter(
        safeArea: safeArea,
        triggerOffset: triggerOffset,
        textColor: blackText,
      ),
      refreshOnStart: refreshOnStart,
      canRefreshAfterNoMore: canRefreshAfterNoMore,
      onRefresh: onRefresh == null
          ? null
          : () async {
              await onRefresh!();
              controller?.finishRefresh();
              controller?.resetFooter();
            },
      onLoad: onLoad == null
          ? null
          : () async {
              final hasMore = await onLoad!();
              controller?.finishLoad(
                hasMore ? IndicatorResult.success : IndicatorResult.noMore,
              );
            },
      child: child,
    );
  }
}
