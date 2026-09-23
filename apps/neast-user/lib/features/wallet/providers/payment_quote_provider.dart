import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/wallet/models/payment_quote_model.dart';
import 'package:neast/features/wallet/services/payment_service.dart';

final paymentQuoteProvider =
    FutureProvider.family<PaymentQuoteModel, double>((ref, amount) async {
  if (amount <= 0) {
    return buildLocalPaymentQuote(amount);
  }

  try {
    return await ref.read(paymentServiceProvider).fetchQuote(amount);
  } catch (_) {
    return buildLocalPaymentQuote(amount);
  }
});
