// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentMethodQuoteModel _$PaymentMethodQuoteModelFromJson(
  Map<String, dynamic> json,
) => _PaymentMethodQuoteModel(
  feePercent: json['fee_percent'] == null
      ? 0
      : _feePercentFromJson(json['fee_percent']),
  totalAmount: json['total_amount'] == null
      ? '0.00'
      : _amountFromJson(json['total_amount']),
);

Map<String, dynamic> _$PaymentMethodQuoteModelToJson(
  _PaymentMethodQuoteModel instance,
) => <String, dynamic>{
  'fee_percent': instance.feePercent,
  'total_amount': instance.totalAmount,
};

_PaymentQuoteModel _$PaymentQuoteModelFromJson(Map<String, dynamic> json) =>
    _PaymentQuoteModel(
      amount: json['amount'] == null ? '0.00' : _amountFromJson(json['amount']),
      methods:
          (json['methods'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              PaymentMethodQuoteModel.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$PaymentQuoteModelToJson(_PaymentQuoteModel instance) =>
    <String, dynamic>{'amount': instance.amount, 'methods': instance.methods};
