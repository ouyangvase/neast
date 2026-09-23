import 'package:neast/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/main/pages/main_screen.dart';
import 'package:neast/main.dart';

/// 简化的认证工具类
class AuthUtils {
  /// 处理登出
  static Future<void> handleLogout(WidgetRef ref, BuildContext context) async {
    logger.d("处理用户登出...");
    
    // 清除组织数据
    _clearAllAppData(ref);
    
    
    // 执行登出
    // final authService = ref.read(_authServiceProvider);
    // await authService.logout();
    
    // 刷新providers状态
    // ref.invalidate(authServiceProvider);
    ref.invalidate(isLoggedInProvider);
    
    // 重置底部导航选中索引为 0（Scan）
    // ref.read(selectedIndexProvider.notifier).state = MainTab.scan;
    
    // 使用replaceAll清空路由栈并导航到登录页
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
    
    logger.d("登出完成，已跳转到登录页");
  }
  
  /// 清除所有应用数据
  static void _clearAllAppData(WidgetRef ref) {
    logger.d("正在清除应用数据...");
    
    logger.d("应用数据清除完成");
  }
  
  /// 处理认证错误（拦截器使用）
  static void handleAuthError(GlobalKey<NavigatorState>? navigatorKey) {
    // 获取context并导航到登录页
    final context = navigatorKey?.currentContext;
    if (context != null) {
      logger.d("处理认证错误，准备重定向到登录页...");

      // 获取ProviderContainer
      final container = ProviderScope.containerOf(context, listen: false);

      // 重置底部导航选中索引为 0（Scan）
      container.read(selectedIndexProvider.notifier).state = MainTab.scan;
      
      // 清空路由栈并导航到登录页
      GoRouter.of(context).go(AppRoutes.login);
      
      logger.d("已重定向到登录页");
    }
  }
} 