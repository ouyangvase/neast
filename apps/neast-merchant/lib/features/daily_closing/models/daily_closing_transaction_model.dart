import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neast/core/utils/number_format_extension.dart';

// ignore_for_file: invalid_annotation_target

part 'daily_closing_transaction_model.freezed.dart';
part 'daily_closing_transaction_model.g.dart';

String _readDecimalString(Object? value) => value?.toString() ?? '0.00';

@freezed
abstract class DailyClosingTransactionModel with _$DailyClosingTransactionModel {
  const DailyClosingTransactionModel._();

  const factory DailyClosingTransactionModel({
    @Default(0) int id,
    @Default('') String time,
    @JsonKey(name: 'user_name') @Default('') String userName,
    @Default(0) int points,
    @JsonKey(fromJson: _readDecimalString) @Default('0.00') String amount,
  }) = _DailyClosingTransactionModel;

  factory DailyClosingTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$DailyClosingTransactionModelFromJson(json);

  String get formattedPoints => '-${points.withComma}';
}
