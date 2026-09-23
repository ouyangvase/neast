import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_topup_model.freezed.dart';
part 'wallet_topup_model.g.dart';

// ignore_for_file: invalid_annotation_target

String _amountFromJson(dynamic value) {
  if (value == null) return '0';
  return value.toString();
}

int _statusFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

@freezed
abstract class WalletTopupModel with _$WalletTopupModel {
  const WalletTopupModel._();

  const factory WalletTopupModel({
    required int id,
    @JsonKey(name: 'merchant_id') required int merchantId,
    @JsonKey(fromJson: _amountFromJson) @Default('0') String amount,
    @JsonKey(name: 'payment_method') @Default('') String paymentMethod,
    @JsonKey(name: 'order_id') @Default('') String orderId,
    @JsonKey(fromJson: _statusFromJson) @Default(0) int status,
    @JsonKey(name: 'txn_id') @Default('') String txnId,
    @Default('') String channel,
    @JsonKey(name: 'paid_at') @Default('') String paidAt,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
  }) = _WalletTopupModel;

  factory WalletTopupModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTopupModelFromJson(json);

  String get displayDate {
    if (paidAt.isEmpty) return '';
    try {
      final normalized = paidAt.replaceFirst(' ', 'T');
      final date = DateTime.parse(normalized);
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return paidAt;
    }
  }

  double get amountValue => double.tryParse(amount) ?? 0;
}

@freezed
abstract class WalletTopupListResponse with _$WalletTopupListResponse {
  const factory WalletTopupListResponse({
    @Default([]) List<WalletTopupModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(15) int limit,
  }) = _WalletTopupListResponse;

  factory WalletTopupListResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletTopupListResponseFromJson(json);
}

@freezed
abstract class WalletTopupOrder with _$WalletTopupOrder {
  const factory WalletTopupOrder({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'payment_url') @Default('') String paymentUrl,
  }) = _WalletTopupOrder;

  factory WalletTopupOrder.fromJson(Map<String, dynamic> json) =>
      _$WalletTopupOrderFromJson(json);
}
