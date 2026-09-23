// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) =>
    _AppConfigModel(
      showAlphaNotice: json['show_alpha_notice'] as bool? ?? false,
      paymentProcessingFees:
          (json['payment_processing_fees'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          defaultPaymentProcessingFees,
    );

Map<String, dynamic> _$AppConfigModelToJson(_AppConfigModel instance) =>
    <String, dynamic>{
      'show_alpha_notice': instance.showAlphaNotice,
      'payment_processing_fees': instance.paymentProcessingFees,
    };
