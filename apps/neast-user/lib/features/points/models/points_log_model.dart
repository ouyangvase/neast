import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'points_log_model.freezed.dart';
part 'points_log_model.g.dart';



// ignore_for_file: invalid_annotation_target

@freezed
abstract class PointsLogModel with _$PointsLogModel {
  const PointsLogModel._();

  const factory PointsLogModel({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @Default(0) int points,
    @Default('') String title,
    @Default('') String subtitle,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
  }) = _PointsLogModel;

  factory PointsLogModel.fromJson(Map<String, dynamic> json) =>
      _$PointsLogModelFromJson(json);

  String get pointsLabel {
    final sign = points >= 0 ? '+' : '';
    return '$sign${NumberFormat('#,###').format(points)} pts';
  }
}

@freezed
abstract class PointsLogListResponse with _$PointsLogListResponse {
  const factory PointsLogListResponse({
    @Default([]) List<PointsLogModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(15) int limit,
  }) = _PointsLogListResponse;

  factory PointsLogListResponse.fromJson(Map<String, dynamic> json) =>
      _$PointsLogListResponseFromJson(json);
}
