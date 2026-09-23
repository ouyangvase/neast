import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/reward/models/reward_dashboard_model.dart';

class RewardService {
  RewardService(this._dioClient);

  final DioClient _dioClient;

  Future<RewardDashboardModel> fetchDashboard({
    double? latitude,
    double? longitude,
  }) async {
    final params = <String, dynamic>{};
    if (latitude != null && longitude != null) {
      params['latitude'] = latitude;
      params['longitude'] = longitude;
    }

    final response = await _dioClient.get(
      '/app/reward/dashboard',
      queryParameters: params.isEmpty ? null : params,
    );

    return RewardDashboardModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }
}

final rewardServiceProvider = Provider<RewardService>((ref) {
  return RewardService(ref.watch(dioClientProvider));
});
