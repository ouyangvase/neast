import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:neast/core/router/app_router.dart';
import 'package:neast/core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 设置状态栏样式为亮色（白色文字）
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent, // 状态栏透明
    //     statusBarIconBrightness: Brightness.light, // 状态栏图标亮色（白色）
    //     statusBarBrightness: Brightness.dark, // iOS 状态栏文字亮色
    //   ),
    // );

    // 使用router provider获取路由
    final router = ref.watch(appRouterProvider);
    
    // 使用主题模式provider获取当前主题模式
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      routerConfig: router,
      title: 'YaGuo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      // 添加本地化支持
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 支持的语言列表
      supportedLocales: const [
        Locale('en'),
      ],
      locale: const Locale('en'),
      // 同时初始化EasyLoading和SmartDialog
      builder: (context, child) {
        child = EasyLoading.init()(context, child);

        //锁定文字缩放比例
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child,
        );

        // 最外层包 FlutterSmartDialog
        return FlutterSmartDialog(child: child);
      },
    );
  }
}