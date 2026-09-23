import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neast/features/coupon/models/coupon_model.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';

part 'home_dashboard_model.freezed.dart';
part 'home_dashboard_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class HomeJourneyModel with _$HomeJourneyModel {
  const factory HomeJourneyModel({
    @JsonKey(name: 'maxStreakMonths') @Default(0) int maxStreakMonths,
    @Default('') String streakLabel,
    @Default('') String streakStatus,
  }) = _HomeJourneyModel;

  factory HomeJourneyModel.fromJson(Map<String, dynamic> json) =>
      _$HomeJourneyModelFromJson(json);
}

@freezed
abstract class HomeBannerModel with _$HomeBannerModel {
  const factory HomeBannerModel({
    required int id,
    @Default('') String image,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @Default('') String link,
  }) = _HomeBannerModel;

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerModelFromJson(json);
}

@freezed
abstract class HomeDashboardModel with _$HomeDashboardModel {
  const factory HomeDashboardModel({
    @JsonKey(name: 'nextRent') RentModel? nextRent,
    @JsonKey(name: 'todayReward') CouponModel? todayReward,
    @JsonKey(name: 'nearbyDeals') @Default([]) List<MerchantModel> nearbyDeals,
    @Default(HomeJourneyModel()) HomeJourneyModel journey,
    @Default([]) List<HomeBannerModel> banners,
  }) = _HomeDashboardModel;

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardModelFromJson(json);
}
