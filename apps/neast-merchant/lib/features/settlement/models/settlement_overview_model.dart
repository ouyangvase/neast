import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/utils/number_format_extension.dart';

// ignore_for_file: invalid_annotation_target

part 'settlement_overview_model.freezed.dart';
part 'settlement_overview_model.g.dart';

String _readDecimalString(Object? value) => value?.toString() ?? '0.00';

@freezed
abstract class SettlementOverviewModel with _$SettlementOverviewModel {
  const SettlementOverviewModel._();

  const factory SettlementOverviewModel({
    int? id,
    @JsonKey(name: 'bill_month') @Default('') String billMonth,
    @JsonKey(name: 'merchant_id') @Default(0) int merchantId,
    @JsonKey(fromJson: _readDecimalString) @Default('0.00') String amount,
    @Default(0) int points,
    @JsonKey(name: 'is_paid') @Default(0) int isPaid,
    @Default(0) int redeemed,
    @JsonKey(name: 'show_pay_now') @Default(false) bool showPayNow,
  }) = _SettlementOverviewModel;

  factory SettlementOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementOverviewModelFromJson(json);

  String get periodLabel {
    final parsed = _parseBillMonth();
    if (parsed == null) {
      return billMonth;
    }
    return DateFormat('MMM yyyy', 'en_US').format(parsed);
  }

  String get formattedAmount {
    final value = double.tryParse(amount);
    if (value == null) {
      return amount.isEmpty ? '0.00' : amount;
    }
    return value.decimalWithComma;
  }

  String get formattedPoints => points.withComma;

  String get formattedRedeemed => redeemed.withComma;

  String? get dueDateLabel {
    if (!showPayNow) {
      return null;
    }
    final parsed = _parseBillMonth();
    if (parsed == null) {
      return null;
    }
    final dueDate = DateTime(parsed.year, parsed.month + 1, 10);
    return 'Due ${DateFormat('dd MMM yyyy', 'en_US').format(dueDate)}';
  }

  DateTime? _parseBillMonth() {
    final parts = billMonth.split('-');
    if (parts.length != 2) {
      return null;
    }
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null || month < 1 || month > 12) {
      return null;
    }
    return DateTime(year, month);
  }
}

@freezed
abstract class SettlementPayOrder with _$SettlementPayOrder {
  const factory SettlementPayOrder({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'payment_url') @Default('') String paymentUrl,
    @JsonKey(name: 'bill_id') required int billId,
  }) = _SettlementPayOrder;

  factory SettlementPayOrder.fromJson(Map<String, dynamic> json) =>
      _$SettlementPayOrderFromJson(json);
}
