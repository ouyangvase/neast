// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refer_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReferDashboardModel _$ReferDashboardModelFromJson(Map<String, dynamic> json) =>
    _ReferDashboardModel(
      totalEarnedPoints: (json['total_earned_points'] as num?)?.toInt() ?? 0,
      invitedCount: (json['invited_count'] as num?)?.toInt() ?? 0,
      maxInviteLimit: (json['max_invite_limit'] as num?)?.toInt() ?? 4,
      nextRewardPoints: (json['next_reward_points'] as num?)?.toInt() ?? 0,
      invitationCode: json['invitation_code'] as String? ?? '',
      inviteeRewardPoints:
          (json['invitee_reward_points'] as num?)?.toInt() ?? 0,
      inviteUrl: json['invite_url'] as String? ?? '',
    );

Map<String, dynamic> _$ReferDashboardModelToJson(
  _ReferDashboardModel instance,
) => <String, dynamic>{
  'total_earned_points': instance.totalEarnedPoints,
  'invited_count': instance.invitedCount,
  'max_invite_limit': instance.maxInviteLimit,
  'next_reward_points': instance.nextRewardPoints,
  'invitation_code': instance.invitationCode,
  'invitee_reward_points': instance.inviteeRewardPoints,
  'invite_url': instance.inviteUrl,
};
