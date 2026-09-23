import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/utils/number_format_extension.dart';
import 'package:neast/features/give_points/utils/give_points_points_util.dart';

// ignore_for_file: invalid_annotation_target

part 'transaction_record_model.freezed.dart';
part 'transaction_record_model.g.dart';

String _readDecimalString(Object? value) => value?.toString() ?? '0.00';

/// 交易记录 Tab 类型。
enum TransactionTab { points, redeemed }

@freezed
abstract class TransactionPointsItemModel with _$TransactionPointsItemModel {
  const factory TransactionPointsItemModel({
    @Default(0) int id,
    @JsonKey(fromJson: _readDecimalString) @Default('0.00') String amount,
    @Default(0) int points,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
  }) = _TransactionPointsItemModel;

  factory TransactionPointsItemModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionPointsItemModelFromJson(json);
}

@freezed
abstract class TransactionRedeemedItemModel with _$TransactionRedeemedItemModel {
  const factory TransactionRedeemedItemModel({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'redeemed_at') @Default('') String redeemedAt,
  }) = _TransactionRedeemedItemModel;

  factory TransactionRedeemedItemModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionRedeemedItemModelFromJson(json);
}

@freezed
abstract class TransactionRecord with _$TransactionRecord {
  const TransactionRecord._();

  const factory TransactionRecord({
    required int id,
    required String title,
    required String subtitle,
    String? pointsLabel,
  }) = _TransactionRecord;

  factory TransactionRecord.fromPointsItem(TransactionPointsItemModel item) {
    final amount = GivePointsPointsUtil.formatAmountDisplay(item.amount);

    return TransactionRecord(
      id: item.id,
      title: 'Receipt RM$amount',
      subtitle: TransactionDateFormat.dateTime(item.createdAt),
      pointsLabel: '+${item.points.withComma} pts',
    );
  }

  factory TransactionRecord.fromRedeemedItem(TransactionRedeemedItemModel item) {
    final name = item.name.trim();

    return TransactionRecord(
      id: item.id,
      title: name.isEmpty ? '-' : name,
      subtitle: TransactionDateFormat.dateTime(item.redeemedAt),
    );
  }
}

abstract final class TransactionDateFormat {
  static String dateTime(String value) {
    final dateTime = _parseDateTime(value);
    if (dateTime == null) {
      return value;
    }
    return DateFormat('dd MMM yyyy, HH:mm', 'en_US').format(dateTime);
  }

  static DateTime? _parseDateTime(String value) {
    if (value.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(value.replaceFirst(' ', 'T'));
    } catch (_) {
      return null;
    }
  }
}
