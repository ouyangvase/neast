import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neast_landlords/core/constants/app_constants.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/core/providers/shared_providers.dart';
import 'package:neast_landlords/core/router/app_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/main.dart';
import 'package:neast_landlords/features/auth/models/country_code_model.dart';
import 'package:neast_landlords/features/auth/models/login_response.dart';
import 'package:neast_landlords/core/utils/landlord_session_reset.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';
import 'package:neast_landlords/features/auth/provider/login_provider.dart';
import 'package:neast_landlords/features/push/services/push_notification_service.dart';

class AuthService {
  AuthService(this._dioClient, this._prefs);

  final DioClient _dioClient;
  final SharedPreferences _prefs;

  Future<List<CountryCodeModel>> fetchCountryCodes() async {
    final response = await _dioClient.get('/landlord/auth/country-codes');
    final data = response['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => CountryCodeModel.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.code.isNotEmpty)
        .toList();
  }

  Future<void> sendCode({
    required String phone,
    required AuthMode mode,
  }) async {
    await _dioClient.post('/landlord/auth/send-code', data: {
      'phone': phone,
      'scene': mode.scene,
    });
  }

  Future<LoginResponse> login({
    required String phone,
    required String code,
  }) async {
    final response = await _dioClient.post('/landlord/auth/login', data: {
      'phone': phone,
      'code': code,
    });

    final loginResponse =
        LoginResponse.fromJson(response['data'] as Map<String, dynamic>);
    await saveLoginData(loginResponse);

    return loginResponse;
  }

  Future<LoginResponse> register({
    required String phone,
    required String code,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _dioClient.post('/landlord/auth/register', data: {
      'phone': phone,
      'code': code,
      'first_name': firstName,
      'last_name': lastName,
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

  Future<void> sendCode({
    required String phone,
    required AuthMode mode,
  }) async {
    await ref.read(authServiceProvider).sendCode(phone: phone, mode: mode);
  }

  Future<LoginResponse?> login({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await ref.read(authServiceProvider).login(
            phone: phone,
            code: code,
          );
      state = true;
      await ref.read(landlordInfoProvider.notifier).refresh();
      return response;
    } on DioException {
      rethrow;
    } catch (e) {
      logger.e('Login failed: $e');
      rethrow;
    }
  }

  Future<LoginResponse?> register({
    required String phone,
    required String code,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await ref.read(authServiceProvider).register(
            phone: phone,
            code: code,
            firstName: firstName,
            lastName: lastName,
          );
      state = true;
      await ref.read(landlordInfoProvider.notifier).refresh();
      return response;
    } on DioException {
      rethrow;
    } catch (e) {
      logger.e('Register failed: $e');
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

    clearLandlordSessionState(ref);
    state = false;
    await ref.read(authServiceProvider).logout();
    logger.d('Logged out');
    ref.read(appRouterProvider).go(AppRoutes.login);
    scheduleLandlordSessionCacheInvalidation(ref);
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
