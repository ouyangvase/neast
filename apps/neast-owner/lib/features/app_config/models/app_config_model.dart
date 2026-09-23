import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class AppConfigModel with _$AppConfigModel {
  const factory AppConfigModel({
    @JsonKey(name: 'show_alpha_notice') @Default(false) bool showAlphaNotice,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);
}
