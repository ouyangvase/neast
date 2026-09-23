import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neast/core/utils/number_format_extension.dart';

// ignore_for_file: invalid_annotation_target

part 'daily_closing_summary_model.freezed.dart';
part 'daily_closing_summary_model.g.dart';

String _readDecimalString(Object? value) => value?.toString() ?? '0.00';

@freezed
abstract class DailyClosingSummaryModel with _$DailyClosingSummaryModel {
  const DailyClosingSummaryModel._();

  const factory DailyClosingSummaryModel({
    @Default(0) int redeemed,
    @Default(0) int points,
    @Default(0) int customers,
    @JsonKey(name: 'commission_rm', fromJson: _readDecimalString)
    @Default('0.00')
    String commissionRm,
  }) = _DailyClosingSummaryModel;

  factory DailyClosingSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailyClosingSummaryModelFromJson(json);

  String get formattedCommission {
    final amount = double.tryParse(commissionRm);
    if (amount == null) {
      return commissionRm.isEmpty ? '0.00' : commissionRm;
    }
    return amount.toStringAsFixed(2);
  }

  String get formattedPoints => points.withComma;

  String get formattedRedeemed => redeemed.withComma;

  String get formattedCustomers => customers.withComma;
}
