// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointsExpiringModel _$PointsExpiringModelFromJson(Map<String, dynamic> json) =>
    _PointsExpiringModel(
      points: (json['points'] as num?)?.toInt() ?? 0,
      expiredDate: json['expired_date'] as String? ?? '',
    );

Map<String, dynamic> _$PointsExpiringModelToJson(
  _PointsExpiringModel instance,
) => <String, dynamic>{
  'points': instance.points,
  'expired_date': instance.expiredDate,
};

_PointsDashboardTierModel _$PointsDashboardTierModelFromJson(
  Map<String, dynamic> json,
) => _PointsDashboardTierModel(
  current: json['current'] == null
      ? const RewardTierItemModel(id: 1)
      : RewardTierItemModel.fromJson(json['current'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PointsDashboardTierModelToJson(
  _PointsDashboardTierModel instance,
) => <String, dynamic>{'current': instance.current};

_PointsDashboardModel _$PointsDashboardModelFromJson(
  Map<String, dynamic> json,
) => _PointsDashboardModel(
  points: (json['points'] as num?)?.toInt() ?? 0,
  tier: json['tier'] == null
      ? const PointsDashboardTierModel()
      : PointsDashboardTierModel.fromJson(json['tier'] as Map<String, dynamic>),
  expiring: json['expiring'] == null
      ? null
      : PointsExpiringModel.fromJson(json['expiring'] as Map<String, dynamic>),
  voucherCount: (json['voucher_count'] as num?)?.toInt() ?? 0,
  inviterRewardPoints: (json['inviter_reward_points'] as num?)?.toInt() ?? 0,
  inviteeRewardPoints: (json['invitee_reward_points'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PointsDashboardModelToJson(
  _PointsDashboardModel instance,
) => <String, dynamic>{
  'points': instance.points,
  'tier': instance.tier,
  'expiring': instance.expiring,
  'voucher_count': instance.voucherCount,
  'inviter_reward_points': instance.inviterRewardPoints,
  'invitee_reward_points': instance.inviteeRewardPoints,
};
