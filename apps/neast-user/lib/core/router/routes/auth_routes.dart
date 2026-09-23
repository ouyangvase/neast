import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/auth/pages/full_data_screen.dart';
import 'package:neast/features/auth/pages/login_screen.dart';
import 'package:neast/features/auth/pages/verify_screen.dart';

/// 淡入淡出缩放页面过渡动画
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
      // 淡入动画
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      );

      // 缩放动画（从 0.8 到 1.0）
      final scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );

      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: child,
        ),
      );
    },
  );
}

final List<GoRoute> authRoutes = [
  // 登录页面
  GoRoute(
    path: AppRoutes.login,
    name: 'login',
    pageBuilder: (context, state) {
      final fromSplash = state.uri.queryParameters['fromSplash'] == 'true';
      if (fromSplash) {
        return _fadeScaleTransitionPage(
          child: const LoginScreen(),
          key: state.pageKey,
        );
      }
      return MaterialPage(
        key: state.pageKey,
        child: const LoginScreen(),
      );
    },
  ),

  // 验证码页面
  GoRoute(
    path: AppRoutes.verify,
    name: 'verify',
    builder: (context, state) {
      final contact = state.uri.queryParameters['contact'] ?? '';

      return VerifyScreen(
        contact: contact,
      );
    },
  ),

  // 填写个人资料
  GoRoute(
    path: AppRoutes.fullData,
    name: 'fullData',
    builder: (context, state) => const FullDataScreen(),
  ),
]; 