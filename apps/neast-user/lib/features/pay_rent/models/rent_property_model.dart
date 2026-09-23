import 'package:freezed_annotation/freezed_annotation.dart';

part 'rent_property_model.freezed.dart';
part 'rent_property_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class RentPropertyModel with _$RentPropertyModel {
  const factory RentPropertyModel({
    required int id,
    @Default('') String sn,
    @Default('') String name,
    @JsonKey(name: 'landlord_name') @Default('') String landlordName,
  }) = _RentPropertyModel;

  factory RentPropertyModel.fromJson(Map<String, dynamic> json) =>
      _$RentPropertyModelFromJson(json);
}
