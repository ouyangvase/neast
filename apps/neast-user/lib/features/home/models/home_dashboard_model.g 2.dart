// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeJourneyModel _$HomeJourneyModelFromJson(Map<String, dynamic> json) =>
    _HomeJourneyModel(
      maxStreakMonths: (json['maxStreakMonths'] as num?)?.toInt() ?? 0,
      streakLabel: json['streakLabel'] as String? ?? '',
      streakStatus: json['streakStatus'] as String? ?? '',
    );

Map<String, dynamic> _$HomeJourneyModelToJson(_HomeJourneyModel instance) =>
    <String, dynamic>{
      'maxStreakMonths': instance.maxStreakMonths,
      'streakLabel': instance.streakLabel,
      'streakStatus': instance.streakStatus,
    };

_HomeBannerModel _$HomeBannerModelFromJson(Map<String, dynamic> json) =>
    _HomeBannerModel(
      id: (json['id'] as num).toInt(),
      image: json['image'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );

Map<String, dynamic> _$HomeBannerModelToJson(_HomeBannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'image_url': instance.imageUrl,
      'link': instance.link,
    };

_HomeDashboardModel _$HomeDashboardModelFromJson(Map<String, dynamic> json) =>
    _HomeDashboardModel(
      nextRent: json['nextRent'] == null
          ? null
          : RentModel.fromJson(json['nextRent'] as Map<String, dynamic>),
      todayReward: json['todayReward'] == null
          ? null
          : CouponModel.fromJson(json['todayReward'] as Map<String, dynamic>),
      nearbyDeals:
          (json['nearbyDeals'] as List<dynamic>?)
              ?.map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      journey: json['journey'] == null
          ? const HomeJourneyModel()
          : HomeJourneyModel.fromJson(json['journey'] as Map<String, dynamic>),
      banners:
          (json['banners'] as List<dynamic>?)
              ?.map((e) => HomeBannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HomeDashboardModelToJson(_HomeDashboardModel instance) =>
    <String, dynamic>{
      'nextRent': instance.nextRent,
      'todayReward': instance.todayReward,
      'nearbyDeals': instance.nearbyDeals,
      'journey': instance.journey,
      'banners': instance.banners,
    };
