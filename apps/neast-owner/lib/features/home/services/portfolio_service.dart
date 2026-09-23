import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/home/models/portfolio_snapshot_models.dart';

class PortfolioService {
  PortfolioService(this._dioClient);

  final DioClient _dioClient;

  Future<PortfolioDetailModel> fetchDetail() async {
    final response = await _dioClient.get('/landlord/portfolio/detail');

    return PortfolioDetailModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }
}

final portfolioServiceProvider = Provider<PortfolioService>((ref) {
  return PortfolioService(ref.watch(dioClientProvider));
});
