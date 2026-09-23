import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target

part 'rent_item_model.freezed.dart';
part 'rent_item_model.g.dart';

String _readAmountString(Object? value) => value?.toString() ?? '0';

/// 租金状态。
@JsonEnum(valueField: 'value')
enum RentStatus {
  @JsonValue('overdue')
  overdue('overdue'),
  @JsonValue('due_soon')
  dueSoon('due_soon');

  const RentStatus(this.value);

  final String value;
}

@freezed
abstract class RentItemModel with _$RentItemModel {
  const RentItemModel._();

  const factory RentItemModel({
    @Default(0) int id,
    @JsonKey(name: 'tenant_initials') @Default('') String initials,
    @JsonKey(name: 'tenant_name') @Default('') String name,
    @JsonKey(name: 'unit_address') @Default('') String address,
    @JsonKey(name: 'status_text') @Default('') String statusText,
    @JsonKey(fromJson: _readAmountString) @Default('0') String amount,
    @JsonKey(name: 'property_name') @Default('') String propertyName,
    @JsonKey(name: 'property_address') @Default('') String propertyAddress,
    @JsonKey(name: 'rental_date') @Default('') String rentalDate,
    @JsonKey(name: 'file_url') @Default('') String fileUrl,
    @Default(RentStatus.overdue) RentStatus status,
  }) = _RentItemModel;

  factory RentItemModel.fromJson(Map<String, dynamic> json) =>
      _$RentItemModelFromJson(json);

  bool get isOverdue => status == RentStatus.overdue;

  bool get isDueSoon => status == RentStatus.dueSoon;
}
