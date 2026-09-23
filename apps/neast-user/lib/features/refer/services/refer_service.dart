import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/refer/models/refer_dashboard_model.dart';

class ReferService {
  ReferService(this._dioClient);

  final DioClient _dioClient;

  Future<ReferDashboardModel> fetchDashboard() async {
    final response = await _dioClient.get('/app/refer/dashboard');
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return ReferDashboardModel.fromJson(data);
  }
}

final referServiceProvider = Provider<ReferService>((ref) {
  return ReferService(ref.watch(dioClientProvider));
});
