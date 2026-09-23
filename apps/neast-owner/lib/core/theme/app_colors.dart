import 'package:flutter/material.dart';

/// 应用语义色（亮/暗两套可控）。
///
/// 约束：light 下的色值必须与历史硬编码保持一致（例如 0xFF4ADB77）。
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brandBlue,
    required this.darkGreen,
    required this.blackText,
  });

  /// 品牌蓝色
  final Color brandBlue;

  /// 暗绿色
  final Color darkGreen;

  /// 黑色字体
  final Color blackText;

  static const AppColors light = AppColors(
    brandBlue: Color(0xFF0851AA),
    darkGreen: Color(0xFF3EBF7A),
    blackText: Color(0xFF0F172A),
  );

  /// 暗色目前先给一套默认值（后续你可以集中调整）。
  static const AppColors dark = AppColors(
    brandBlue: Color(0xFF0D2567),
    darkGreen: Color(0xFF3EBF7A),
    blackText: Color(0xFF0F172A),
  );

  @override
  AppColors copyWith({
    Color? brandBlue,
    Color? darkGreen,
    Color? blackText,
  }) {
    return AppColors(
      brandBlue: brandBlue ?? this.brandBlue,
      darkGreen: darkGreen ?? this.darkGreen,
      blackText: blackText ?? this.blackText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brandBlue: Color.lerp(brandBlue, other.brandBlue, t) ?? brandBlue,
      darkGreen: Color.lerp(darkGreen, other.darkGreen, t) ?? darkGreen,
      blackText: Color.lerp(blackText, other.blackText, t) ?? blackText,
    );
  }
}

extension AppColorsContextX on BuildContext {
  AppColors get appColors {
    final ext = Theme.of(this).extension<AppColors>();
    assert(ext != null, 'AppColors is not attached to ThemeData.extensions');
    return ext ?? AppColors.light;
  }
}

