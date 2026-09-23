import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:neast/features/reward/models/reward_dashboard_model.dart';

part 'points_dashboard_model.freezed.dart';
part 'points_dashboard_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class PointsExpiringModel with _$PointsExpiringModel {
  const PointsExpiringModel._();

  const factory PointsExpiringModel({
    @Default(0) int points,
    @JsonKey(name: 'expired_date') @Default('') String expiredDate,
  }) = _PointsExpiringModel;

  factory PointsExpiringModel.fromJson(Map<String, dynamic> json) =>
      _$PointsExpiringModelFromJson(json);

  String get title =>
      '${NumberFormat('#,###').format(points)}pts expiring soon';

  String get subtitle => expiredDate.isEmpty
      ? ''
      : 'use before $expiredDate';
}

@freezed
abstract class PointsDashboardTierModel with _$PointsDashboardTierModel {
  const factory PointsDashboardTierModel({
    @Default(RewardTierItemModel(id: 1)) RewardTierItemModel current,
  }) = _PointsDashboardTierModel;

  factory PointsDashboardTierModel.fromJson(Map<String, dynamic> json) =>
      _$PointsDashboardTierModelFromJson(json);
}

@freezed
abstract class PointsDashboardModel with _$PointsDashboardModel {
  const PointsDashboardModel._();

  const factory PointsDashboardModel({
    @Default(0) int points,
    @Default(PointsDashboardTierModel()) PointsDashboardTierModel tier,
    PointsExpiringModel? expiring,
    @JsonKey(name: 'voucher_count') @Default(0) int voucherCount,
    @JsonKey(name: 'inviter_reward_points') @Default(0) int inviterRewardPoints,
    @JsonKey(name: 'invitee_reward_points') @Default(0) int inviteeRewardPoints,
  }) = _PointsDashboardModel;

  factory PointsDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$PointsDashboardModelFromJson(json);

  String get pointsDisplay => NumberFormat('#,###').format(points);

  String get tierLabel {
    final name = tier.current.name.trim();
    if (name.isEmpty) return '- tier';
    return '$name tier';
  }

  String get referralSubtitle =>
      'Earn up to ${NumberFormat('#,###').format(inviterRewardPoints)} pts from referrals';

  String get referralHighlight =>
      'Your friend gets ${NumberFormat('#,###').format(inviteeRewardPoints)} pts too';
}
