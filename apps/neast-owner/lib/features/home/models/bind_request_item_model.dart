import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target

part 'bind_request_item_model.freezed.dart';
part 'bind_request_item_model.g.dart';

String _readString(dynamic value) => value?.toString() ?? '';

/// 待绑定申请项。
@freezed
abstract class BindRequestItemModel with _$BindRequestItemModel {
  const factory BindRequestItemModel({
    @Default(0) int id,
    @Default('') String initials,
    @JsonKey(name: 'user_name') @Default('') String userName,
    @JsonKey(fromJson: _readString) @Default('0') String rent,
    @Default('') String payday,
    @JsonKey(name: 'property_name') @Default('') String propertyName,
    @JsonKey(name: 'property_address') @Default('') String propertyAddress,
    @JsonKey(name: 'rental_date') @Default('') String rentalDate,
    @JsonKey(name: 'file_url') @Default('') String fileUrl,
  }) = _BindRequestItemModel;

  factory BindRequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$BindRequestItemModelFromJson(json);
}
