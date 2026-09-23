import 'dart:async';

import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:neast_landlords/core/constants/app_constants.dart';
import 'package:neast_landlords/core/providers/shared_providers.dart';
import 'package:neast_landlords/core/utils/toast_util.dart';

class DioClient {
  final Dio _dio;
  final Logger _logger;
  final SharedPreferences _prefs;
  final Ref _ref;

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  static const String _refreshPath = '/landlord/auth/refresh-token';
  

  DioClient(this._dio, this._logger, this._prefs, this._ref) {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: Duration(milliseconds: AppConstants.apiConnectTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.apiReceiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_logInterceptor());
    _dio.interceptors.add(_responseInterceptor());
  }

  // 授权拦截器 - 添加Token
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _prefs.getString(AppConstants.accessTokenKey);
        if (token != null) {
          options.headers['Authorization'] = token;
        }
        return handler.next(options);
      },
    );
  }

  // 日志拦截器
  Interceptor _logInterceptor() {
    return InterceptorsWrapper(
      onResponse: (response, handler) {
        String queryString = '';
        if (response.requestOptions.queryParameters.isNotEmpty) {
          queryString = Uri(queryParameters: response.requestOptions.queryParameters.map((key, value) => 
            MapEntry(key, value.toString()))).query;
          queryString = '?$queryString';
        }
  
        _logger.d('REQUEST[${response.requestOptions.method}] => PATH: ${response.requestOptions.path}$queryString');
        _logger.d('Headers: ${response.requestOptions.headers}');
        _logger.d('Request Data: ${response.requestOptions.data}');
        _logger.d('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        _logger.d('Response: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        _logger.e('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
        _logger.e('Error: ${error.message}');
        return handler.next(error);
      },
    );
  }

  // 响应拦截器 - 处理服务端响应
  Interceptor _responseInterceptor() {
    return InterceptorsWrapper(
      onResponse: (response, handler) async {
        // 检查响应数据
        final responseData = response.data;
        if (responseData is! Map<String, dynamic>
            || !responseData.containsKey('code')
            || responseData['code'] is! int) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: 'Request failed: invalid response format',
            ),
          );
        }

        try {
          final responseMessage = _extractMessage(responseData);

          final responseCode = responseData['code'] as int;
          switch (responseCode) {
            case 200: // 成功
              return handler.next(response);
            case 400: // token过期，尝试刷新
              return await _tryRefreshToken(response, handler, responseMessage);
            default: // 其他错误
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  error: responseMessage ?? 'Request failed',
                  response: response,
                ),
              );
          }
        } catch (e) {
          // JSON解析错误或其他异常 - 不显示技术细节
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: 'Request failed: unexpected error',
            ),
          );
        }
      },
      onError: (DioException error, handler) async {
        // 处理请求错误 - 简化错误消息
        String errorMessage = 'Network error';
        
        if (error.type == DioExceptionType.connectionTimeout) {
          errorMessage = 'Network error: connection timed out';
        } else if (error.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Network error: receive timed out';
        } else if (error.type == DioExceptionType.sendTimeout) {
          errorMessage = 'Network error: send timed out';
        } else if (error.type == DioExceptionType.connectionError) {
          errorMessage = 'Network error: unable to connect';
        } else if (error.response != null) {
          if (error.response!.statusCode == 401) {
            logger.e('请求接口: ${error.requestOptions.path}, 需要登录');
            if (_ref.read(authProvider)) {
              errorMessage = 'Login expired, please login again';
              await _ref.read(authProvider.notifier).logout();
            } else {
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  response: error.response,
                  type: error.type,
                ),
              );
            }
          } else if (error.response!.statusCode == 404) {
            errorMessage = 'The requested resource was not found';
          } else if (error.response!.statusCode == 500) {
            errorMessage = 'Server error';
          } else {
            // 尝试从响应中提取message
            try {
              final responseData = error.response!.data;
              if (responseData is Map) {
                errorMessage = _extractMessage(
                      Map<String, dynamic>.from(responseData),
                    ) ??
                    'Request failed';
              }
            } catch (e) {
              // 如果提取失败，使用默认消息
              errorMessage = 'Request failed';
            }
          }
        }
        
        return handler.next(
          DioException(
            requestOptions: error.requestOptions,
            error: errorMessage,
            response: error.response,
            type: error.type,
          ),
        );
      },
    );
  }

  String? _extractMessage(Map<String, dynamic> responseData) {
    final message = responseData['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
    final msg = responseData['msg'];
    if (msg is String && msg.isNotEmpty) {
      return msg;
    }
    return null;
  }

  // 尝试刷新token，成功后重试原始请求，失败则退出登录
  Future<void> _tryRefreshToken(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
    String? errorMessage,
  ) async {
    // 重试后仍返回业务 code 400，直接退出，避免死循环
    if (response.requestOptions.extra['_retried'] == true) {
      if (_ref.read(authProvider)) {
        ToastUtil.show(errorMessage ?? 'Login expired, please login again');
        await _ref.read(authProvider.notifier).logout();
      }

      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: errorMessage,
        response: response,
      ));
    }

    final refreshToken = _prefs.getString(AppConstants.refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      if (_ref.read(authProvider)) {
        ToastUtil.show(errorMessage ?? 'Login expired, please login again');
        await _ref.read(authProvider.notifier).logout();
      }

      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: errorMessage,
        response: response,
      ));
    }

    // 已有刷新在进行中，挂起等待结果，避免重复刷新
    if (_isRefreshing) {
      final newToken = await _refreshCompleter!.future;
      return _retryRequest(response, handler, newToken);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      // 使用独立Dio实例发送刷新请求，完全绕过自定义拦截器，避免死循环
      final refreshDio = Dio(_dio.options);
      final refreshResponse = await refreshDio.post<Map<String, dynamic>>(
        _refreshPath,
        queryParameters: {'refreshToken': refreshToken},
      );

      final refreshBody = refreshResponse.data;
      logger.d('刷新token响应: $refreshBody');
      if (refreshBody is! Map<String, dynamic> ||
          refreshBody['code'] is! int ||
          refreshBody['code'] != 200) {
        throw Exception('刷新token响应异常');
      }

      final tokenData = refreshBody['data'] as Map<String, dynamic>;
      await _saveTokenData(tokenData);
      final newAccessToken = tokenData['accessToken'] as String;

      // 通知所有挂起的请求：刷新成功，携带新token
      _refreshCompleter!.complete(newAccessToken);

      logger.d('刷新token成功: $newAccessToken');

      return _retryRequest(response, handler, newAccessToken);
    } catch (e) {
      _logger.e('刷新token失败: $e');
      // 通知所有挂起的请求：刷新失败
      _refreshCompleter!.complete(null);
      if (_ref.read(authProvider)) {
        ToastUtil.show('Login expired, please login again');
        await _ref.read(authProvider.notifier).logout();
      }

      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: 'Login expired, please login again',
        response: response,
      ));
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  // 用新token重试原始请求
  Future<void> _retryRequest(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
    String? newToken,
  ) async {
    if (newToken == null) {
      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: 'Login expired, please login again',
        response: response,
      ));
    }
    try {
      // 不传headers，由_authInterceptor从缓存读取最新token自动注入
      final retryResponse = await _dio.request<dynamic>(
        response.requestOptions.path,
        data: response.requestOptions.data,
        queryParameters: response.requestOptions.queryParameters,
        options: Options(
          method: response.requestOptions.method,
          extra: {...response.requestOptions.extra, '_retried': true},
        ),
      );
      return handler.resolve(retryResponse);
    } catch (e) {
      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: 'Request failed, please try again later',
        response: response,
      ));
    }
  }

  // 将刷新后的token数据写入缓存
  Future<void> _saveTokenData(Map<String, dynamic> data) async {
    final accessToken = data['accessToken'] as String?;
    final newRefreshToken = data['refreshToken'] as String?;
    final expiresTime = data['expiresTime'];

    if (accessToken != null) {
      await _prefs.setString(AppConstants.accessTokenKey, accessToken);
    }
    if (newRefreshToken != null) {
      await _prefs.setString(AppConstants.refreshTokenKey, newRefreshToken);
    }
    if (expiresTime is int) {
      await _prefs.setInt(AppConstants.expiresTimeKey, expiresTime);
    }
  }

  // 处理认证错误
  // void _handleAuthError() {
  //   // 清除本地存储
  //   _prefs.remove(AppConstants.accessTokenKey);
  //   _prefs.remove(AppConstants.refreshTokenKey);
  //   _prefs.remove(AppConstants.expiresTimeKey);
    
  //   // 使用AuthUtils处理导航
  //   AuthUtils.handleAuthError(_ref);
  // }

  // GET请求
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException {
      rethrow;
    } catch (e) {
      // 非Dio异常，记录并包装为友好消息
      _logger.e('非Dio异常[GET]: $e');
      throw DioException(requestOptions: RequestOptions(path: path), error: 'Request failed');
    }
  }

  // POST请求
  Future<dynamic> post(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException {
      rethrow;
    } catch (e) {
      _logger.e('非Dio异常[POST]: $e');
      throw DioException(requestOptions: RequestOptions(path: path), error: 'Request failed');
    }
  }

  // PUT请求
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException{
      rethrow;
    } catch (e) {
      _logger.e('非Dio异常[PUT]: $e');
      throw DioException(requestOptions: RequestOptions(path: path), error: 'Request failed');
    }
  }

  // DELETE请求
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException {
      rethrow;
    } catch (e) {
      _logger.e('非Dio异常[DELETE]: $e');
      throw DioException(requestOptions: RequestOptions(path: path), error: 'Request failed');
    }
  }

  // 文件上传请求
  Future<dynamic> uploadFile(
    String path,
    FormData formData, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response.data;
    } on DioException {
      rethrow;
    } catch (e) {
      _logger.e('非Dio异常[上传文件]: $e');
      throw DioException(requestOptions: RequestOptions(path: path), error: 'File upload failed');
    }
  }
}

// DioClient的Provider
final dioClientProvider = Provider<DioClient>((ref) {
  final dio = Dio();
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      levelEmojis: {
        Level.debug: '📡',
        Level.info: '📡',
      },
    ),
  );
  final prefs = ref.watch(sharedPreferencesProvider);
  return DioClient(dio, logger, prefs, ref);
}); 