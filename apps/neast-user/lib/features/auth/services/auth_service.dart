import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neast/core/constants/app_constants.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/core/providers/shared_providers.dart';
import 'package:neast/core/router/app_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/utils/user_session_reset.dart';
import 'package:neast/main.dart';
import 'package:neast/features/auth/models/country_code_model.dart';
import 'package:neast/features/auth/models/login_response.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/account/services/user_service.dart';
import 'package:neast/features/home/providers/home_dashboard_provider.dart';
import 'package:neast/features/main/pages/main_screen.dart';
import 'package:neast/features/push/services/push_notification_service.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';

class AuthService {
  AuthService(this._dioClient, this._prefs);

  final DioClient _dioClient;
  final SharedPreferences _prefs;

  Future<List<CountryCodeModel>> fetchCountryCodes() async {
    final response = await _dioClient.get('/app/auth/country-codes');
    final data = response['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => CountryCodeModel.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.code.isNotEmpty)
        .toList();
  }

  Future<void> sendCode({
    required String account,
  }) async {
    await _dioClient.post('/app/auth/send-code', data: {
      'account': account,
    });
  }

  Future<LoginResponse> login({
    required String account,
    required String code,
  }) async {
    final response = await _dioClient.post('/app/auth/login', data: {
      'account': account,
      'code': code,
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

  void markAuthenticated() {
    state = true;
  }

  Future<void> sendCode({
    required String account,
  }) async {
    await ref.read(authServiceProvider).sendCode(
          account: account,
        );
  }

  Future<LoginResponse?> login({
    required String account,
    required String code,
  }) async {
    try {
      final response = await ref.read(authServiceProvider).login(
            account: account,
            code: code,
          );
      state = true;
      await ref.read(userProfileProvider.notifier).refresh();
      ref.invalidate(homeDashboardProvider);
      ref.invalidate(rewardDashboardProvider);
      return response;
    } on DioException {
      rethrow;
    } catch (e) {
      logger.e('Login failed: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    if (!state) return;

    clearUserSessionState(ref);
    state = false;
    await ref.read(authServiceProvider).logout();
    logger.d('Logged out');
    ref.read(selectedIndexProvider.notifier).state = MainTab.account;
    ref.read(appRouterProvider).go(AppRoutes.main);
    scheduleUserSessionCacheInvalidation(ref);

    unawaited(
      ref
          .read(pushNotificationServiceProvider)
          .deleteToken()
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              logger.w('删除 FCM Token 超时，但不影响登出');
            },
          )
          .catchError((Object e) {
            logger.w('删除 FCM Token 失败（不影响登出）: $e');
          }),
    );
  }

  Future<void> completeProfile({
    required String firstName,
    required String lastName,
    required String idType,
    required String idNumber,
    String? idValidUntil,
    String? address,
    String? invitationCode,
    String? email,
  }) async {
    await ref.read(userServiceProvider).completeInitialProfile(
          firstName: firstName,
          lastName: lastName,
          idType: idType,
          idNumber: idNumber,
          idValidUntil: idValidUntil,
          address: address,
          invitationCode: invitationCode,
          email: email,
        );
    ref.invalidate(homeDashboardProvider);
    ref.invalidate(rewardDashboardProvider);
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

final countryCodesProvider = FutureProvider<List<CountryCodeModel>>((ref) {
  return ref.watch(authServiceProvider).fetchCountryCodes();
});
