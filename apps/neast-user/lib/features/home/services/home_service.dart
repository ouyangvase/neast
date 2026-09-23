import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/home/models/home_dashboard_model.dart';

class HomeService {
  HomeService(this._dioClient);

  final DioClient _dioClient;

  Future<HomeDashboardModel> fetchDashboard({
    double? latitude,
    double? longitude,
  }) async {
    final params = <String, dynamic>{};
    if (latitude != null && longitude != null) {
      params['latitude'] = latitude;
      params['longitude'] = longitude;
    }

    final response = await _dioClient.get(
      '/app/home/dashboard',
      queryParameters: params.isEmpty ? null : params,
    );

    return HomeDashboardModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }
}

final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeService(ref.watch(dioClientProvider));
});
