import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/settlement/models/settlement_overview_model.dart';

class SettlementService {
  SettlementService(this._dioClient);

  final DioClient _dioClient;

  Future<SettlementOverviewModel> fetchOverview() async {
    final response = await _dioClient.get('/merchant/settlement/overview');
    return SettlementOverviewModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  Future<SettlementOverviewModel> payByWallet({
    required int billId,
    required String paymentMethod,
  }) async {
    final response = await _dioClient.post(
      '/merchant/settlement/pay/wallet',
      data: {
        'bill_id': billId,
        'payment_method': paymentMethod,
      },
    );
    return SettlementOverviewModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  Future<SettlementPayOrder> createPayOrder({
    required int billId,
    required String paymentMethod,
    String? paymentChannel,
  }) async {
    final data = <String, dynamic>{
      'bill_id': billId,
      'payment_method': paymentMethod,
    };
    if (paymentChannel != null && paymentChannel.isNotEmpty) {
      data['payment_channel'] = paymentChannel;
    }

    final response = await _dioClient.post(
      '/merchant/settlement/pay/create',
      data: data,
    );
    return SettlementPayOrder.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }
}

final settlementServiceProvider = Provider<SettlementService>((ref) {
  return SettlementService(ref.watch(dioClientProvider));
});
