import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neast/core/constants/app_constants.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/core/providers/shared_providers.dart';
import 'package:neast/core/router/app_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/utils/merchant_session_reset.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/main.dart';
import 'package:neast/features/auth/models/login_response.dart';
import 'package:neast/features/push/services/push_notification_service.dart';

class AuthService {
  AuthService(this._dioClient, this._prefs);

  final DioClient _dioClient;
  final SharedPreferences _prefs;

  Future<LoginResponse> login({
    required String account,
    required String password,
  }) async {
    final response = await _dioClient.post('/merchant/auth/login', data: {
      'account': account.trim(),
      'password': password,
    });

    final loginResponse =
        LoginResponse.fromJson(response['data'] as Map<String, dynamic>);
    await saveLoginData(loginResponse);

    return loginResponse;
  }

  Future<void> logout() async {
    await _clearUserData();
  }

  bool isLoggedIn() {
    final refreshToken = _prefs.getString(AppConstants.refreshTokenKey);
    return refreshToken != null && refreshToken.isNotEmpty;
  }

  Future<void> saveLoginData(LoginResponse loginResponse) async {
    await _prefs.setString(
      AppConstants.accessTokenKey,
      loginResponse.accessToken,
    );
    await _prefs.setString(
      AppConstants.refreshTokenKey,
      loginResponse.refreshToken,
    );
    await _prefs.setInt(
      AppConstants.expiresTimeKey,
      loginResponse.expiresTime,
    );
  }

  Future<void> _clearUserData() async {
    await _prefs.remove(AppConstants.accessTokenKey);
    await _prefs.remove(AppConstants.refreshTokenKey);
    await _prefs.remove(AppConstants.expiresTimeKey);
  }
}

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.read(authServiceProvider).isLoggedIn();
  }

  Future<bool> login({
    required String account,
    required String password,
  }) async {
    try {
      await ref.read(authServiceProvider).login(
            account: account,
            password: password,
          );
      state = true;
      await ref.read(merchantInfoProvider.notifier).refresh();
      return true;
    } on DioException {
      rethrow;
    } catch (e) {
      logger.e('Login failed: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    if (!state) return;

    try {
      await ref
          .read(pushNotificationServiceProvider)
          .deleteToken()
          .timeout(const Duration(seconds: 3), onTimeout: () {
        logger.w('删除 FCM Token 超时，但不影响登出');
      });
    } catch (e) {
      logger.w('删除 FCM Token 失败（不影响登出）: $e');
    }

    clearMerchantSessionState(ref);
    state = false;
    await ref.read(authServiceProvider).logout();
    logger.d('Logged out');
    ref.read(appRouterProvider).go(AppRoutes.login);
    scheduleMerchantSessionCacheInvalidation(ref);
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthService(dioClient, prefs);
});
