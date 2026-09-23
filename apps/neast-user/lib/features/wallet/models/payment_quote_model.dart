import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neast/features/app_config/models/app_config_model.dart';

part 'payment_quote_model.freezed.dart';
part 'payment_quote_model.g.dart';

// ignore_for_file: invalid_annotation_target

String _amountFromJson(dynamic value) {
  if (value == null) return '0.00';
  return value.toString();
}

double _feePercentFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

@freezed
abstract class PaymentMethodQuoteModel with _$PaymentMethodQuoteModel {
  const factory PaymentMethodQuoteModel({
    @JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson)
    @Default(0)
    double feePercent,
    @JsonKey(name: 'total_amount', fromJson: _amountFromJson)
    @Default('0.00')
    String totalAmount,
  }) = _PaymentMethodQuoteModel;

  factory PaymentMethodQuoteModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodQuoteModelFromJson(json);
}

@freezed
abstract class PaymentQuoteModel with _$PaymentQuoteModel {
  const PaymentQuoteModel._();

  const factory PaymentQuoteModel({
    @JsonKey(fromJson: _amountFromJson) @Default('0.00') String amount,
    @Default({}) Map<String, PaymentMethodQuoteModel> methods,
  }) = _PaymentQuoteModel;

  factory PaymentQuoteModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentQuoteModelFromJson(json);

  PaymentMethodQuoteModel? methodQuote(String methodId) => methods[methodId];
}

PaymentQuoteModel buildLocalPaymentQuote(double amount) {
  const fees = defaultPaymentProcessingFees;

  final methods = <String, PaymentMethodQuoteModel>{};
  for (final entry in fees.entries) {
    final totalAmount = (amount * (1 + entry.value / 100));
    methods[entry.key] = PaymentMethodQuoteModel(
      feePercent: entry.value,
      totalAmount: _formatLocalAmount(totalAmount),
    );
  }

  return PaymentQuoteModel(
    amount: _formatLocalAmount(amount),
    methods: methods,
  );
}

String _formatLocalAmount(double value) {
  return value.toStringAsFixed(2);
}
