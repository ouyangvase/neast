import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'refer_dashboard_model.freezed.dart';
part 'refer_dashboard_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class ReferDashboardModel with _$ReferDashboardModel {
  const ReferDashboardModel._();

  const factory ReferDashboardModel({
    @JsonKey(name: 'total_earned_points') @Default(0) int totalEarnedPoints,
    @JsonKey(name: 'invited_count') @Default(0) int invitedCount,
    @JsonKey(name: 'max_invite_limit') @Default(4) int maxInviteLimit,
    @JsonKey(name: 'next_reward_points') @Default(0) int nextRewardPoints,
    @JsonKey(name: 'invitation_code') @Default('') String invitationCode,
    @JsonKey(name: 'invitee_reward_points') @Default(0) int inviteeRewardPoints,
    @JsonKey(name: 'invite_url') @Default('') String inviteUrl,
  }) = _ReferDashboardModel;

  factory ReferDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$ReferDashboardModelFromJson(json);

  String get totalEarnedLabel =>
      '${NumberFormat('#,###').format(totalEarnedPoints)}pts';

  String get invitesLabel => '$invitedCount/$maxInviteLimit';

  String get nextRewardLabel =>
      '${NumberFormat('#,###').format(nextRewardPoints)}pts';

  String get inviteeRewardText =>
      '${NumberFormat('#,###').format(inviteeRewardPoints)}pts';
}
