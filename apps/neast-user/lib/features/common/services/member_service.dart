import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/common/models/member_model.dart';
import 'package:neast/main.dart';

class   MemberService {
  final DioClient _dioClient;
  MemberService(this._dioClient);

  Future<MemberModel> getMemberInfo() async {
    try {
      final response = await _dioClient.get('/member/info');
      return MemberModel.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      logger.d('获取会员信息失败: $e');
      rethrow;
    } catch (e) {
      throw Exception('获取会员信息失败: $e');
    }
  }

  Future<void> changeAvatarType(int avatarType) async {
    try {
      await _dioClient.post('/member/change_avatar_type', data: {
        'avatar_type': avatarType,
      });
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('更换头像失败: $e');
    }
  }
}

final memberServiceProvider = Provider<MemberService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MemberService(dioClient);
});