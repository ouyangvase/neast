import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 应用主题配置
class AppTheme {
  // 私有构造函数
  AppTheme._();

  //checkbox选中图表
  static const String checkBoxCheckedIcon  = 'assets/images/check-selected.svg';

  //checkbox未选中图表
  static const String checkBoxUncheckedIcon = 'assets/images/check-unselect.svg';
  
  // 应用主题色
  static const Color primaryColor = Color(0xFF4ADB77);
  
  // Light主题
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    extensions: const <ThemeExtension<dynamic>>[
      AppColors.light,
    ],
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      iconTheme: IconThemeData(color: Colors.black),
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    // 设置 iOS 风格的页面转场动画（所有平台统一使用）
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
  
  // Dark主题
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xFF17171B),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors.dark,
    ],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.lightBlue[300],
      ),
    ),
    // 设置 iOS 风格的页面转场动画（所有平台统一使用）
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

/// 主题模式Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light; // 默认使用系统主题
}); 