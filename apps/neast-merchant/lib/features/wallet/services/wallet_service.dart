import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/wallet/models/wallet_topup_model.dart';

class WalletService {
  WalletService(this._dioClient);

  final DioClient _dioClient;

  Future<List<WalletTopupModel>> fetchTopupList({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dioClient.get(
      '/merchant/wallet/topup/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
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
      '/merchant/wallet/topup/create',
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
  final value = double.tryParse(balance);
  if (value == null) return balance;
  final formatted = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  return _addThousandsSeparator(formatted);
}

String _addThousandsSeparator(String text) {
  final parts = text.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  if (parts.length == 1) return intPart;
  return '$intPart.${parts[1]}';
}
