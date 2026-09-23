import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

// ignore_for_file: invalid_annotation_target

const defaultPaymentProcessingFees = {
  'fpx': 0.0,
  'tng': 1.6,
  'grab': 1.6,
  'visa': 3.5,
};

@freezed
abstract class AppConfigModel with _$AppConfigModel {
  const factory AppConfigModel({
    @JsonKey(name: 'show_alpha_notice') @Default(false) bool showAlphaNotice,
    @JsonKey(name: 'payment_processing_fees')
    @Default(defaultPaymentProcessingFees)
    Map<String, double> paymentProcessingFees,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);
}
