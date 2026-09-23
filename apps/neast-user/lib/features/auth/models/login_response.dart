import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 登录响应数据模型
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required int expiresTime,
    @Default(false) bool profileCompleted,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
