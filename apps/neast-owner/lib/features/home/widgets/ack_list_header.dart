import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// Ack 列表页顶部：139deg 渐变背景 + 返回 + 标题。
class AckListHeader extends StatelessWidget {
  const AckListHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.trailing,
  });

  final String title;
  final bool showBackButton;
  final Widget? trailing;

  static const aspectRatio = 372 / 133;
  static const _toolbarHeight = 58.0;

  /// CSS: linear-gradient(139deg, #E3EFFF 0%, #79A1D3 100%)
  static const _gradient = LinearGradient(
    colors: [
      Color(0xFFE3EFFF),
      Color(0xFF79A1D3),
    ],
    transform: GradientRotation(139 * math.pi / 180),
  );

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: _gradient),
          child: SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: _toolbarHeight,
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
                    if (showBackButton)
                      Positioned(
                        left: 8,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (trailing != null)
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(child: trailing!),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
