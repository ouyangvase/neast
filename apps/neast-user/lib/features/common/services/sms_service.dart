import 'package:neast/features/auth/models/sms_scene_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/main.dart';

class SmsService {
  final DioClient _dioClient;
  SmsService(this._dioClient);

  Future<void> sendSmsCode(String phone, SmsSceneEnum scene) async {
    try {
      await _dioClient.post(
        '/member/auth/send-sms-code',
        data: {
          'mobile': phone,
          'scene': scene.type,
        }
      );
    } catch(e) {
      logger.e('发送短信验证码失败: $e');
      rethrow;
    }
  }
}

final smsServiceProvider = Provider<SmsService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SmsService(dioClient);
});