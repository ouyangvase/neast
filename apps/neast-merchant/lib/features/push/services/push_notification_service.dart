import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/constants/app_constants.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/core/providers/shared_providers.dart';
import 'package:neast/core/router/app_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/notification/providers/notification_list_provider.dart';
import 'package:neast/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  PushNotificationService(this._dioClient, this._prefs, this._ref);

  final DioClient _dioClient;
  final SharedPreferences _prefs;
  final Ref _ref;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isLocalNotificationsInitialized = false;
  bool _listenersRegistered = false;
  int _tokenRetryCount = 0;
  static const int _maxTokenRetryCount = 8;

  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;

  bool _isApnsNotReadyError(Object error) {
    return error.toString().contains('apns-token-not-set');
  }

  Future<void> initialize() async {
    try {
      logger.d('开始初始化推送服务...');

      await _initializeLocalNotifications();

      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      logger.d('推送权限状态: ${settings.authorizationStatus}');

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        logger.w('用户未授权推送通知: ${settings.authorizationStatus}');
        return;
      }

      if (Platform.isIOS) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      _registerListenersIfNeeded();
      await _fetchAndSaveToken();
    } catch (e, stackTrace) {
      logger.e('初始化推送服务失败: $e', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    if (_isLocalNotificationsInitialized) {
      return;
    }

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleLocalNotificationClick(response.payload);
      },
    );

    _isLocalNotificationsInitialized = true;
  }

  void _registerListenersIfNeeded() {
    if (_listenersRegistered) {
      return;
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      logger.d('FCM Token 已刷新: $newToken');
      _tokenRetryCount = 0;
      _saveTokenToServer(newToken);
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageClick);

    _listenersRegistered = true;

    unawaited(_handleInitialMessage());
  }

  Future<void> _handleInitialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessageClick(initialMessage);
    }
  }

  Future<bool> _waitForApnsToken({
    int maxAttempts = 10,
    Duration interval = const Duration(seconds: 2),
  }) async {
    if (!Platform.isIOS) {
      return true;
    }

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null && apnsToken.isNotEmpty) {
          logger.d('APNS Token 已就绪');
          return true;
        }
      } catch (e) {
        if (!_isApnsNotReadyError(e)) {
          logger.w('获取 APNS Token 异常: $e');
        }
      }

      logger.d('等待 APNS Token... ($attempt/$maxAttempts)');
      if (attempt < maxAttempts) {
        await Future.delayed(interval);
      }
    }

    logger.w(
      'APNS Token 仍未就绪。请确认：1) 使用真机调试 2) Xcode 已开启 Push Notifications '
      '3) Firebase 已上传 APNs 密钥',
    );
    return false;
  }

  Future<void> _fetchAndSaveToken() async {
    if (Platform.isIOS) {
      final apnsReady = await _waitForApnsToken();
      if (!apnsReady) {
        _scheduleTokenRetry();
        return;
      }
    }

    try {
      final token = await _firebaseMessaging.getToken().timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );

      if (token != null) {
        _tokenRetryCount = 0;
        await _saveTokenToServer(token);
        return;
      }

      logger.w('FCM Token 获取失败或超时，将在后台重试');
      _scheduleTokenRetry();
    } catch (e) {
      if (_isApnsNotReadyError(e)) {
        logger.w('APNS 尚未就绪，稍后重试获取 FCM Token');
      } else {
        logger.e('获取 FCM Token 异常: $e');
      }
      _scheduleTokenRetry();
    }
  }

  void _scheduleTokenRetry() {
    if (_tokenRetryCount >= _maxTokenRetryCount) {
      logger.w('FCM Token 重试次数已达上限，等待 onTokenRefresh 回调');
      return;
    }

    _tokenRetryCount += 1;
    final delaySeconds = _tokenRetryCount <= 3 ? 3 : 5;

    Future.delayed(Duration(seconds: delaySeconds), () async {
      await _fetchAndSaveToken();
    });
  }

  Future<void> _saveTokenToServer(String token) async {
    try {
      final accessToken = _prefs.getString(AppConstants.accessTokenKey);
      if (accessToken == null || accessToken.isEmpty) {
        logger.d('商家未登录，暂不保存 FCM Token');
        return;
      }

      final platform = Platform.isIOS ? 'ios' : 'android';

      await _dioClient.post('/merchant/push/add-fcm-token', data: {
        'token': token,
        'platform': platform,
      });

      logger.d('FCM Token 已保存到服务器');
    } catch (e) {
      logger.e('保存 FCM Token 失败: $e');
    }
  }

  void _refreshNotificationList() {
    try {
      _ref.read(notificationListProvider.notifier).refresh(isLoading: false);
      logger.d('已触发消息列表刷新');
    } catch (e) {
      logger.e('刷新消息数据失败: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    logger.d('收到前台消息: ${message.notification?.title}');
    _refreshNotificationList();

    if (Platform.isIOS) {
      return;
    }

    await _showAndroidLocalNotification(message);
  }

  Future<void> _showAndroidLocalNotification(RemoteMessage message) async {
    try {
      if (!_isLocalNotificationsInitialized) {
        await _initializeLocalNotifications();
        await Future.delayed(const Duration(milliseconds: 300));
      }

      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'high importance channel',
        channelDescription: 'high importance channel',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      final notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _localNotifications.show(
        notificationId,
        message.notification?.title ?? 'New Message',
        message.notification?.body ?? '',
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      logger.e('显示 Android 前台通知失败: $e');
    }
  }

  void _handleLocalNotificationClick(String? payload) {
    if (payload == null || payload.isEmpty) {
      return;
    }

    _clearAppBadge();
    _navigateToNotification();
  }

  void _handleBackgroundMessageClick(RemoteMessage message) {
    logger.d('用户点击了通知: ${message.notification?.title}');
    _clearAppBadge();
    _navigateToNotification();
  }

  void _navigateToNotification() {
    _ref.read(appRouterProvider).push(AppRoutes.notification);
  }

  Future<void> _clearAppBadge() async {
    try {
      final isSupported = await AppBadgePlus.isSupported();
      if (isSupported) {
        await AppBadgePlus.updateBadge(0);
      }
    } catch (e) {
      logger.e('清空应用角标失败: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsReady = await _waitForApnsToken(maxAttempts: 5);
        if (!apnsReady) {
          return null;
        }
      }
      return await _firebaseMessaging.getToken();
    } catch (e) {
      if (_isApnsNotReadyError(e)) {
        logger.w('获取 FCM Token 失败: APNS 尚未就绪');
      } else {
        logger.e('获取 FCM Token 失败: $e');
      }
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      String? token;
      try {
        token = await _firebaseMessaging.getToken();
      } catch (e) {
        if (!_isApnsNotReadyError(e)) {
          rethrow;
        }
      }
      if (token != null) {
        try {
          await _dioClient.post('/merchant/push/delete-fcm-token', data: {
            'token': token,
          });
        } catch (e) {
          logger.e('删除服务器 Token 失败: $e');
        }
      }

      await _firebaseMessaging.deleteToken();
      logger.d('FCM Token 已删除');
    } catch (e) {
      logger.e('删除 FCM Token 失败: $e');
    }
  }
}

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return PushNotificationService(dioClient, prefs, ref);
});
