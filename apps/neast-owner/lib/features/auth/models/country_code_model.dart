import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_code_model.freezed.dart';
part 'country_code_model.g.dart';

/// 手机区号，如 `+60`。
@freezed
abstract class CountryCodeModel with _$CountryCodeModel {
  const factory CountryCodeModel({
    @Default('') String code,
  }) = _CountryCodeModel;

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) =>
      _$CountryCodeModelFromJson(json);
}
