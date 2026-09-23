import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 登录 / 验证页顶部渐变头部（独立区域，与下方内容背景分界清晰）。
class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    this.title = 'Login in',
  });

  final String title;

  /// 标题栏高度（不含状态栏与底部延伸）。
  static const toolbarHeight = 56.0;

  /// 标题下方额外渐变高度。
  static const bottomExtension = 20.0;

  /// 头部内容总高度（不含状态栏）。
  static const contentHeight = toolbarHeight + bottomExtension;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        height: topPadding + contentHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF7EB3E8),
              Color(0xFF9EC8F0),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Column(
            children: [
              SizedBox(
                height: toolbarHeight,
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: context.canPop()
                          ? IconButton(
                              onPressed: () => context.pop(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: brandBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: bottomExtension),
            ],
          ),
        ),
      ),
    );
  }
}
