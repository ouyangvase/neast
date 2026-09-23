import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/give_points/models/points_setting_model.dart';

class PointsSettingService {
  PointsSettingService(this._dioClient);

  final DioClient _dioClient;

  Future<PointsSettingModel> fetchSetting() async {
    final response = await _dioClient.get('/merchant/points-setting');
    return PointsSettingModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

final pointsSettingServiceProvider = Provider<PointsSettingService>((ref) {
  return PointsSettingService(ref.watch(dioClientProvider));
});
