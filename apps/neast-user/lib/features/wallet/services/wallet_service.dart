import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/wallet/data/wallet_config.dart';
import 'package:neast/features/wallet/models/wallet_topup_model.dart';

class WalletService {
  WalletService(this._dioClient);

  final DioClient _dioClient;

  Future<String> fetchBalance() async {
    final response = await _dioClient.get('/app/wallet/balance');
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return (data['balance'] ?? '0').toString();
  }

  Future<List<WalletTopupModel>> fetchTopupList({
    int page = 1,
    int limit = 10,
    int? year,
    int? month,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (year != null && year > 0) {
      queryParameters['year'] = year;
    }
    if (month != null && month >= 1 && month <= 12) {
      queryParameters['month'] = month;
    }

    final response = await _dioClient.get(
      '/app/wallet/topup/list',
      queryParameters: queryParameters,
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return WalletTopupListResponse.fromJson(data).items;
  }

  Future<WalletTopupOrder> createTopupOrder({
    required double amount,
    required String paymentMethod,
    String? paymentChannel,
  }) async {
    final payload = <String, dynamic>{
      'amount': amount,
      'payment_method': paymentMethod,
    };
    if (paymentChannel != null && paymentChannel.isNotEmpty) {
      payload['payment_channel'] = paymentChannel;
    }

    final response = await _dioClient.post(
      '/app/wallet/topup/create',
      data: payload,
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return WalletTopupOrder.fromJson(data);
  }
}

final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService(ref.watch(dioClientProvider));
});

String formatWalletBalanceDisplay(String balance) {
  return formatAmountWithThousandsSeparator(balance);
}
