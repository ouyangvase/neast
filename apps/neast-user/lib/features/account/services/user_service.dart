import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/account/models/user_profile_model.dart';

class UserService {
  UserService(this._dioClient);

  final DioClient _dioClient;

  Future<UserProfileModel> fetchProfile() async {
    final response = await _dioClient.get('/app/user/profile');
    return UserProfileModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  /// 个人资料页单项编辑（不含证件类型、证件号）。
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? idValidUntil,
    String? address,
    String? email,
  }) async {
    final data = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'address': address?.trim() ?? '',
      'email': email?.trim() ?? '',
    };

    final normalized = normalizeProfileApiDate(idValidUntil);
    if (normalized != null && normalized.isNotEmpty) {
      data['id_valid_until'] = normalized;
    }

    await _dioClient.post('/app/user/profile', data: data);
  }

  /// 注册 / 登录后首次完善资料（含证件类型、证件号）。
  Future<void> completeInitialProfile({
    required String firstName,
    required String lastName,
    required String idType,
    required String idNumber,
    String? idValidUntil,
    String? address,
    String? invitationCode,
    String? email,
  }) async {
    final data = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'id_type': idType,
      'id_number': idNumber,
    };

    if (idType == 'passport') {
      final normalized = normalizeProfileApiDate(idValidUntil);
      if (normalized != null && normalized.isNotEmpty) {
        data['id_valid_until'] = normalized;
      }
    }

    data['address'] = address?.trim() ?? '';

    final trimmedEmail = email?.trim() ?? '';
    if (trimmedEmail.isNotEmpty) {
      data['email'] = trimmedEmail;
    }

    final trimmedInvitationCode = invitationCode?.trim() ?? '';
    if (trimmedInvitationCode.isNotEmpty) {
      data['invitation_code'] = trimmedInvitationCode;
    }

    await _dioClient.post('/app/user/profile', data: data);
  }

  Future<void> deleteAccount() async {
    await _dioClient.post('/app/user/delete-account');
  }
}

/// 将接口日期规范为 YYYY-MM-DD，避免带时间导致校验失败。
String? normalizeProfileApiDate(String? date) {
  if (date == null || date.trim().isEmpty) {
    return null;
  }
  final parsed = DateTime.tryParse(date.trim());
  if (parsed == null) {
    return date.trim();
  }
  final month = parsed.month.toString().padLeft(2, '0');
  final day = parsed.day.toString().padLeft(2, '0');
  return '${parsed.year}-$month-$day';
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref.watch(dioClientProvider));
});
