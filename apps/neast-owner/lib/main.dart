import 'package:neast_landlords/core/providers/shared_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neast_landlords/core/app.dart';
import 'package:logger/logger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:neast_landlords/firebase_messaging_background.dart';
import 'package:neast_landlords/firebase_options.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1
  ),
);

Future<void> main() async {
  try {
    // 确保Flutter绑定初始化 - 这一步必须在使用任何平台通道前完成
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // 保留原生启动图，待 Flutter 首帧绘制后再由 SplashScreen 移除，避免跳变
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    logger.d('Firebase initialized');

    // 全局仅竖屏正立。若某页需要横屏：在该页 initState 调用
    // SystemChrome.setPreferredOrientations 包含 landscape，dispose 时恢复为下方列表；
    // iOS 需在 Info.plist 的 UISupportedInterfaceOrientations 中声明对应方向。
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);
    
    // 初始化SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    logger.d("SharedPreferences initialized successfully");

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏透明
      statusBarIconBrightness: Brightness.light, // 状态栏图标颜色
    ));

    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..maskType = EasyLoadingMaskType.black
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..userInteractions = false // 禁止点击遮罩层后还可以交互
      ..dismissOnTap = false;


    // final container = ProviderContainer(
    //   overrides: [
    //     sharedPreferencesProvider.overrideWithValue(prefs),
    //   ],
    // );

    // 运行应用
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs)
        ],
        child: App(),
      ),
    );
  } catch (e, stackTrace) {
    // 记录和显示初始化错误
    logger.e("初始化时发生错误: $e", error: e, stackTrace: stackTrace);
    
    // 显示一个简单的错误屏幕，而不是完全崩溃
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red.shade100,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    '应用程序初始化失败',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('错误详情: $e', 
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
