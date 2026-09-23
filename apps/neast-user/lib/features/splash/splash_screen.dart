import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/router/auth_navigation.dart';
// import 'package:neast/features/app_config/models/app_config_model.dart';
// import 'package:neast/features/app_config/providers/app_config_provider.dart';

/// 启动页面 - 与原生启动图保持一致，实现无感过渡
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const String _iosImage = 'assets/images/launch_ios.png';
  static const String _androidImage = 'assets/images/launch_android.png';
  static const Color _iosBackground = Color(0xFF4A78BD);

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  Future<void> _navigateToNext() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      // ref.read(appConfigProvider.future).catchError((_) {
      //   return const AppConfigModel(showAlphaNotice: false);
      // }),
    ]);
    if (!mounted) return;

    navigateAfterSplash(context, ref);
  }

  @override
  Widget build(BuildContext context) {
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
