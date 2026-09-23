import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target

part 'ack_item_model.freezed.dart';
part 'ack_item_model.g.dart';

String _readString(dynamic value) => value?.toString() ?? '';

/// 待确认收款项。
@freezed
abstract class AckItemModel with _$AckItemModel {
  const AckItemModel._();

  const factory AckItemModel({
    @Default(0) int id,
    @Default('') String initials,
    @Default('') String name,
    @JsonKey(fromJson: _readString) @Default('0') String amount,
    @JsonKey(name: 'paid_text') @Default('') String paidText,
    @JsonKey(name: 'paid_date') @Default('') String paidDate,
    @JsonKey(name: 'property_name') @Default('') String propertyName,
    @JsonKey(name: 'property_address') @Default('') String propertyAddress,
    @JsonKey(name: 'rental_date') @Default('') String rentalDate,
    @JsonKey(name: 'file_url') @Default('') String fileUrl,
  }) = _AckItemModel;

  factory AckItemModel.fromJson(Map<String, dynamic> json) =>
      _$AckItemModelFromJson(json);

  String get title => 'RM $amount from $name';
}
