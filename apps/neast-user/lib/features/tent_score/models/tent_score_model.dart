import 'package:freezed_annotation/freezed_annotation.dart';

part 'tent_score_model.freezed.dart';
part 'tent_score_model.g.dart';

/// Tent Score（租客信用评分）概览。
///
/// 字段与 `GET /app/user/tent-score` 对齐，展示文案尽量由后端直出字符串，
/// 后续接入真实计分逻辑时前端无需改动。
@freezed
abstract class TentScoreModel with _$TentScoreModel {
  const TentScoreModel._();

  const factory TentScoreModel({
    @Default(0) int score,
    @Default(1000) int maxScore,
    @Default('') String ratingLabel,
    @Default('') String streakLabel,
    @Default('') String streakStatus,
    @Default(0) int onTimePayments,
    @Default(0) int latePayments,
    @Default('') String totalPaid,
    @Default(0) int verifiedLeases,
    @Default('') String since,
  }) = _TentScoreModel;

  factory TentScoreModel.fromJson(Map<String, dynamic> json) =>
      _$TentScoreModelFromJson(json);

  /// 仪表盘进度比例（0.0 ~ 1.0）。
  double get progress {
    if (maxScore <= 0) return 0;
    return (score / maxScore).clamp(0.0, 1.0);
  }
}
