import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/main/pages/main_screen.dart';
import 'package:neast_landlords/features/splash/splash_screen.dart';

/// 淡入淡出缩放页面过渡动画（启动页往里缩）
Page<void> _fadeScaleTransitionPage({
  required Widget child,
  required LocalKey key,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 新页面淡入动画
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      );

      // 旧页面（启动页）缩小动画
      // secondaryAnimation 用于控制旧页面的退出动画
      final scaleOutAnimation = Tween<double>(
        begin: 1.0,
        end: 0.8,
      ).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInCubic,
        ),
      );

      return Stack(
        children: [
          // 旧页面（启动页）缩小淡出
          if (secondaryAnimation.status != AnimationStatus.dismissed)
            FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
              child: ScaleTransition(
                scale: scaleOutAnimation,
                child: Container(), // 这里会被旧页面填充
              ),
            ),
          // 新页面淡入
          FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        ],
      );
    },
  );
}

final List<GoRoute> shellRoutes = [
  GoRoute(
    path: AppRoutes.splash,
    name: 'splash',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: AppRoutes.main,
    name: 'main',
    pageBuilder: (context, state) {
      final fromSplash = state.uri.queryParameters['fromSplash'] == 'true';

      if (fromSplash) {
        return _fadeScaleTransitionPage(
          child: const MainScreen(),
          key: state.pageKey,
        );
      } else {
        return MaterialPage(
          key: state.pageKey,
          child: const MainScreen(),
        );
      }
    },
  ),
];
