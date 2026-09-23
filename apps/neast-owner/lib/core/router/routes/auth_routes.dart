import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/auth/pages/login_screen.dart';
import 'package:neast_landlords/features/auth/pages/verify_screen.dart';
import 'package:neast_landlords/features/auth/provider/login_provider.dart';

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
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      );

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
  GoRoute(
    path: AppRoutes.verify,
    name: 'verify',
    builder: (context, state) {
      final phone = state.uri.queryParameters['phone'] ?? '';
      final modeValue = state.uri.queryParameters['mode'] ?? AuthMode.login.name;
      final mode = AuthMode.values.firstWhere(
        (item) => item.name == modeValue,
        orElse: () => AuthMode.login,
      );
      final firstName = state.uri.queryParameters['firstName'] ?? '';
      final lastName = state.uri.queryParameters['lastName'] ?? '';

      return VerifyScreen(
        phone: phone,
        mode: mode,
        firstName: firstName,
        lastName: lastName,
      );
    },
  ),
];
