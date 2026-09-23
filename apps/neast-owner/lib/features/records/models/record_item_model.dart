import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

// ignore_for_file: invalid_annotation_target

part 'record_item_model.freezed.dart';
part 'record_item_model.g.dart';

String _amountFromJson(dynamic value) {
  if (value == null) return '0';
  return value.toString();
}

@freezed
abstract class RecordItemModel with _$RecordItemModel {
  const RecordItemModel._();

  const factory RecordItemModel({
    @Default(0) int id,
    @Default('?') String initials,
    @JsonKey(name: 'user_name') @Default('') String userName,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(fromJson: _amountFromJson) @Default('0') String amount,
    @Default('') String avatar,
  }) = _RecordItemModel;

  factory RecordItemModel.fromJson(Map<String, dynamic> json) =>
      _$RecordItemModelFromJson(json);

  String get displayDate {
    if (createdAt.isEmpty) return '';
    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) return createdAt;
    return DateFormat('MMMM d.yyyy', 'en_US').format(parsed);
  }

  String get displayAmount {
    final value = double.tryParse(amount) ?? 0;
    return NumberFormat('#,##0.##', 'en_US').format(value);
  }
}

class RecordListResponse {
  const RecordListResponse({
    required this.items,
    required this.total,
    required this.amountSum,
    required this.page,
    required this.limit,
  });

  final List<RecordItemModel> items;
  final int total;
  final String amountSum;
  final int page;
  final int limit;

  factory RecordListResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map(
              (item) => RecordItemModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList()
        : <RecordItemModel>[];

    return RecordListResponse(
      items: items,
      total: _readInt(json['total']),
      amountSum: json['amount_sum']?.toString() ?? '0',
      page: _readInt(json['page'], fallback: 1),
      limit: _readInt(json['limit'], fallback: 20),
    );
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
