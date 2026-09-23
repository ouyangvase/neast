import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/points/models/points_dashboard_model.dart';
import 'package:neast/features/points/models/points_log_model.dart';

class PointsService {
  PointsService(this._dioClient);

  final DioClient _dioClient;

  Future<PointsDashboardModel> fetchDashboard() async {
    final response = await _dioClient.get('/app/points/dashboard');
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return PointsDashboardModel.fromJson(data);
  }

  Future<List<PointsLogModel>> fetchLogs({
    int page = 1,
    int limit = 15,
  }) async {
    final response = await _dioClient.get(
      '/app/points/logs',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return PointsLogListResponse.fromJson(data).items;
  }
}

final pointsServiceProvider = Provider<PointsService>((ref) {
  return PointsService(ref.watch(dioClientProvider));
});
