import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/give_points/models/give_points_today_commission_model.dart';
import 'package:neast/features/give_points/models/give_points_today_stats_model.dart';

class GivePointsService {
  GivePointsService(this._dioClient);

  final DioClient _dioClient;

  Future<GivePointsTodayCommissionModel> fetchTodayCommission() async {
    final response = await _dioClient.get('/merchant/give-points/today-commission');
    return GivePointsTodayCommissionModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  Future<GivePointsTodayStatsModel> fetchTodayStats() async {
    final response = await _dioClient.get('/merchant/give-points/stats');
    return GivePointsTodayStatsModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  Future<String> fetchCustomerAccountByUserId(int userId) async {
    final response = await _dioClient.get(
      '/merchant/give-points/customer',
      queryParameters: {'user_id': userId},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return (data['account'] as String? ?? '').trim();
  }

  Future<bool> confirmGivePoints({
    required String customer,
    required String amount,
    required int points,
    required int merchantId,
    required String receiptNumber,
    required String receiptPath,
    String notes = '',
  }) async {
    await _dioClient.post(
      '/merchant/give-points/confirm',
      data: {
        'customer': customer,
        'amount': amount,
        'points': points,
        'merchant_id': merchantId,
        'notes': notes,
        'receipt_number': receiptNumber,
        'receipt_path': receiptPath,
      },
    );
    return true;
  }
}

final givePointsServiceProvider = Provider<GivePointsService>((ref) {
  return GivePointsService(ref.watch(dioClientProvider));
});
