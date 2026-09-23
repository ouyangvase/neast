import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
// import 'package:neast/features/app_config/models/app_config_model.dart';
// import 'package:neast/features/app_config/providers/app_config_provider.dart';
import 'package:neast/features/auth/services/auth_service.dart';

/// 启动页面 - 与原生启动图保持一致，实现无感过渡
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const String _iosImage = 'assets/images/launch_ios.png';
  static const String _androidImage = 'assets/images/launch_android.png';
  static const Color _iosBackground = Color(0xFFD7A77B);

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  bool _prepared = false;

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prepared) return;
    _prepared = true;
    precacheImage(AssetImage(_isIOS ? _iosImage : _androidImage), context);
    // 首帧绘制后再移除原生启动图，确保 Flutter 已渲染出一致画面
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  /// 根据用户状态跳转到相应页面
  Future<void> _navigateToNext() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      // ref.read(appConfigProvider.future).catchError((_) {
      //   return const AppConfigModel(showAlphaNotice: false);
      // }),
    ]);
    if (!mounted) return;

    // 检查是否已登录，添加 fromSplash 参数标记来自启动页
    final isLoggedIn = ref.read(isLoggedInProvider);
    if (!mounted) return;

    if (isLoggedIn) {
      context.go('${AppRoutes.main}?fromSplash=true');
    } else {
      context.go('${AppRoutes.login}?fromSplash=true');
    }
  }

  @override
  Widget build(BuildContext context) {
    // iOS：全屏启动图，铺满整个屏幕，与原生 LaunchScreen 一致
    if (_isIOS) {
      return Scaffold(
        backgroundColor: _iosBackground,
        body: SizedBox.expand(
          child: Image.asset(
            _iosImage,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      );
    }

    // Android：白底 + 居中 Logo，尺寸与原生 288dp 一致
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          _androidImage,
          width: 288,
          height: 288,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
