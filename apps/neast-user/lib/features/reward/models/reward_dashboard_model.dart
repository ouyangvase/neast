import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';

part 'reward_dashboard_model.freezed.dart';
part 'reward_dashboard_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class RewardTierItemModel with _$RewardTierItemModel {
  const RewardTierItemModel._();

  const factory RewardTierItemModel({
    required int id,
    @Default('') String name,
    @JsonKey(name: 'min_points') @Default(0) int minPoints,
    @JsonKey(name: 'max_points') @Default(0) int maxPoints,
  }) = _RewardTierItemModel;

  factory RewardTierItemModel.fromJson(Map<String, dynamic> json) =>
      _$RewardTierItemModelFromJson(json);

  String get displayName => '$name Tenant';

  String get pointsRangeLabel {
    if (maxPoints >= 9999999) {
      return '${_formatPoints(minPoints)}+ pts';
    }
    return '${_formatPoints(minPoints)}–${_formatPoints(maxPoints)}pts';
  }

  static String _formatPoints(int value) {
    return NumberFormat('#,###').format(value);
  }
}

@freezed
abstract class RewardTierProgressModel with _$RewardTierProgressModel {
  const RewardTierProgressModel._();

  const factory RewardTierProgressModel({
    required RewardTierItemModel current,
    RewardTierItemModel? next,
    @JsonKey(name: 'pointsToNextTier') @Default(0) int pointsToNextTier,
    @JsonKey(name: 'progressCurrent') @Default(0) int progressCurrent,
    @JsonKey(name: 'progressTarget') @Default(0) int progressTarget,
  }) = _RewardTierProgressModel;

  factory RewardTierProgressModel.fromJson(Map<String, dynamic> json) =>
      _$RewardTierProgressModelFromJson(json);

  double get progress {
    if (next == null) return 1;
    if (progressTarget <= 0) return 0;
    return (progressCurrent / progressTarget).clamp(0.0, 1.0);
  }

  String get progressPointsLabel {
    return '${RewardTierItemModel._formatPoints(progressCurrent)}/'
        '${RewardTierItemModel._formatPoints(progressTarget)} pts';
  }

  String get nextTierLabel => next?.name ?? '';
}

@freezed
abstract class RewardDashboardModel with _$RewardDashboardModel {
  const RewardDashboardModel._();

  const factory RewardDashboardModel({
    @JsonKey(name: 'points') @Default(0) int points,
    @JsonKey(name: 'pointsExpiringText') @Default('') String pointsExpiringText,
    @Default(RewardTierProgressModel(current: RewardTierItemModel(id: 1)))
    RewardTierProgressModel tier,
    @Default([]) List<RewardTierItemModel> tiers,
    @JsonKey(name: 'featuredRewards')
    @Default([])
    List<CouponListItemModel> featuredRewards,
    @JsonKey(name: 'nearbyRewards')
    @Default([])
    List<MerchantModel> nearbyRewards,
  }) = _RewardDashboardModel;

  factory RewardDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$RewardDashboardModelFromJson(json);

  String get pointsDisplay => NumberFormat('#,###').format(points);
}
