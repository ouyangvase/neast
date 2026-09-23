import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/wallet/models/payment_quote_model.dart';

class PaymentService {
  PaymentService(this._dioClient);

  final DioClient _dioClient;

  Future<PaymentQuoteModel> fetchQuote(double amount) async {
    final response = await _dioClient.get(
      '/app/payment/quote',
      queryParameters: {'amount': amount},
    );
    final data = response['data'];
    if (data is! Map) {
      return buildLocalPaymentQuote(amount);
    }
    return PaymentQuoteModel.fromJson(Map<String, dynamic>.from(data));
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(ref.watch(dioClientProvider));
});
