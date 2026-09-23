import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// 品牌顶栏：背景顶图 + 可选返回 + 自定义标题。
///
/// 标题通过 [title] 传入任意 [Widget]，可用 [neastRichTitle] / [plainTitle] 快捷构建。
class NeastBrandHeader extends StatelessWidget {
  const NeastBrandHeader({
    super.key,
    required this.title,
    this.backgroundAsset = 'assets/images/app_header.png',
    this.fillColor = Colors.white,
    this.showBackButton = true,
    this.onBack,
    this.trailing,
  });

  /// 居中标题。
  final Widget title;

  /// 顶图资源路径。
  final String backgroundAsset;

  /// 顶图下方透明缺口处的填充色，需与页面/骨架屏背景一致。
  final Color fillColor;

  /// 是否显示返回按钮。
  final bool showBackButton;

  /// 自定义返回行为，默认 [GoRouter.pop]。
  final VoidCallback? onBack;

  /// 右侧操作区（如按钮），与返回按钮对称布局时使用。
  final Widget? trailing;

  /// 顶图原始尺寸 1500x635，宽度撑满时按该比例渲染（约 150 高）。
  static const double imageAspectRatio = 635 / 1500;

  /// 顶图底部透明缺口约占图高的比例，标题在缺口之上的蓝色区域居中。
  static const double bottomGapRatio = 0.13;

  /// 普通单行标题默认样式。
  static const TextStyle plainTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// 「neast」+ 后缀 品牌标题，如 members / rewards。
  static Widget neastRichTitle(String suffix) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        children: [
          const TextSpan(
            text: 'neast',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          TextSpan(text: suffix),
        ],
      ),
    );
  }

  /// 普通单行标题。
  static Widget plainTitle(String text, {TextStyle? style}) {
    return Text(
      text,
      style: style ?? plainTitleStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topPadding = media.padding.top - 20;
    final imageHeight = media.size.width * imageAspectRatio;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        color: fillColor,
        child: Stack(
          children: [
            Image.asset(
              backgroundAsset,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              bottom: imageHeight * bottomGapRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  title,
                  if (showBackButton)
                    Positioned(
                      left: 8,
                      child: IconButton(
                        onPressed: onBack ?? () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (trailing != null)
                    Positioned(
                      right: 8,
                      child: trailing!,
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
