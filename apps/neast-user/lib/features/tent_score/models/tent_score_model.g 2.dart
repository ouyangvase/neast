// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tent_score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TentScoreModel _$TentScoreModelFromJson(Map<String, dynamic> json) =>
    _TentScoreModel(
      score: (json['score'] as num?)?.toInt() ?? 0,
      maxScore: (json['maxScore'] as num?)?.toInt() ?? 1000,
      ratingLabel: json['ratingLabel'] as String? ?? '',
      streakLabel: json['streakLabel'] as String? ?? '',
      streakStatus: json['streakStatus'] as String? ?? '',
      onTimePayments: (json['onTimePayments'] as num?)?.toInt() ?? 0,
      latePayments: (json['latePayments'] as num?)?.toInt() ?? 0,
      totalPaid: json['totalPaid'] as String? ?? '',
      verifiedLeases: (json['verifiedLeases'] as num?)?.toInt() ?? 0,
      since: json['since'] as String? ?? '',
    );

Map<String, dynamic> _$TentScoreModelToJson(_TentScoreModel instance) =>
    <String, dynamic>{
      'score': instance.score,
      'maxScore': instance.maxScore,
      'ratingLabel': instance.ratingLabel,
      'streakLabel': instance.streakLabel,
      'streakStatus': instance.streakStatus,
      'onTimePayments': instance.onTimePayments,
      'latePayments': instance.latePayments,
      'totalPaid': instance.totalPaid,
      'verifiedLeases': instance.verifiedLeases,
      'since': instance.since,
    };
