import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/home/models/home_dashboard_model.dart';

class HomeService {
  HomeService(this._dioClient);

  final DioClient _dioClient;

  Future<HomeDashboardModel> fetchDashboard() async {
    final response = await _dioClient.get('/landlord/home/detail');

    return HomeDashboardModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }
}

final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeService(ref.watch(dioClientProvider));
});
