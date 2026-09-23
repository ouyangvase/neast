// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RewardTierItemModel _$RewardTierItemModelFromJson(Map<String, dynamic> json) =>
    _RewardTierItemModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      minPoints: (json['min_points'] as num?)?.toInt() ?? 0,
      maxPoints: (json['max_points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RewardTierItemModelToJson(
  _RewardTierItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'min_points': instance.minPoints,
  'max_points': instance.maxPoints,
};

_RewardTierProgressModel _$RewardTierProgressModelFromJson(
  Map<String, dynamic> json,
) => _RewardTierProgressModel(
  current: RewardTierItemModel.fromJson(
    json['current'] as Map<String, dynamic>,
  ),
  next: json['next'] == null
      ? null
      : RewardTierItemModel.fromJson(json['next'] as Map<String, dynamic>),
  pointsToNextTier: (json['pointsToNextTier'] as num?)?.toInt() ?? 0,
  progressCurrent: (json['progressCurrent'] as num?)?.toInt() ?? 0,
  progressTarget: (json['progressTarget'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RewardTierProgressModelToJson(
  _RewardTierProgressModel instance,
) => <String, dynamic>{
  'current': instance.current,
  'next': instance.next,
  'pointsToNextTier': instance.pointsToNextTier,
  'progressCurrent': instance.progressCurrent,
  'progressTarget': instance.progressTarget,
};

_RewardDashboardModel _$RewardDashboardModelFromJson(
  Map<String, dynamic> json,
) => _RewardDashboardModel(
  points: (json['points'] as num?)?.toInt() ?? 0,
  pointsExpiringText: json['pointsExpiringText'] as String? ?? '',
  tier: json['tier'] == null
      ? const RewardTierProgressModel(current: RewardTierItemModel(id: 1))
      : RewardTierProgressModel.fromJson(json['tier'] as Map<String, dynamic>),
  tiers:
      (json['tiers'] as List<dynamic>?)
          ?.map((e) => RewardTierItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  featuredRewards:
      (json['featuredRewards'] as List<dynamic>?)
          ?.map((e) => CouponListItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  nearbyRewards:
      (json['nearbyRewards'] as List<dynamic>?)
          ?.map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$RewardDashboardModelToJson(
  _RewardDashboardModel instance,
) => <String, dynamic>{
  'points': instance.points,
  'pointsExpiringText': instance.pointsExpiringText,
  'tier': instance.tier,
  'tiers': instance.tiers,
  'featuredRewards': instance.featuredRewards,
  'nearbyRewards': instance.nearbyRewards,
};
