
/// 应用常量配置类
class AppConstants {
  // 私有构造函数
  AppConstants._();
  
  // API相关
  static const String apiBaseUrl = 'https://localhost:8080';
  static const int apiConnectTimeout = 15000; // 15秒
  static const int apiReceiveTimeout = 15000; // 15秒
  
  // 缓存相关
  static const String accessTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String expiresTimeKey = 'expires_time';

  // 分页相关
  static const int defaultPageSize = 20;
  static const int defaultInitialPage = 1;
  
  // 动画时长
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

} 