import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// 富文本页面顶部栏：渐变背景 + 返回 + 标题。
class RichTextHeader extends StatelessWidget {
  const RichTextHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFE3EFFF),
              Color(0xFF79A1D3),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.only(bottom: 15),
            height: 58,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 400)],
                    color: brandBlue,
                  ),
                ),
                Positioned(
                  left: 8,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
