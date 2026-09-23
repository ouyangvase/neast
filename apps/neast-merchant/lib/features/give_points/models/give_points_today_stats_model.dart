import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neast/core/utils/number_format_extension.dart';

// ignore_for_file: invalid_annotation_target

part 'give_points_today_stats_model.freezed.dart';
part 'give_points_today_stats_model.g.dart';

String _readDecimalString(Object? value) => value?.toString() ?? '0.00';

@freezed
abstract class GivePointsTodayStatsModel with _$GivePointsTodayStatsModel {
  const GivePointsTodayStatsModel._();

  const factory GivePointsTodayStatsModel({
    @JsonKey(name: 'customers_today') @Default(0) int customersToday,
    @JsonKey(name: 'avg_spend', fromJson: _readDecimalString)
    @Default('0.00')
    String avgSpend,
    @JsonKey(name: 'points_today') @Default(0) int pointsToday,
    @JsonKey(name: 'repeat_customers') @Default(0) int repeatCustomers,
  }) = _GivePointsTodayStatsModel;

  factory GivePointsTodayStatsModel.fromJson(Map<String, dynamic> json) =>
      _$GivePointsTodayStatsModelFromJson(json);

  String get formattedCustomersToday => customersToday.withComma;

  String get formattedAvgSpend {
    final value = double.tryParse(avgSpend);
    if (value == null) {
      return avgSpend.isEmpty ? '0.00' : avgSpend;
    }
    return value.decimalWithComma;
  }

  String get formattedPointsToday => pointsToday.withComma;

  String get formattedRepeatCustomers => repeatCustomers.withComma;
}
