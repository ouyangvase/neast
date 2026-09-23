import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_model.freezed.dart';
part 'merchant_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
abstract class MerchantModel with _$MerchantModel {
  const MerchantModel._();

  const factory MerchantModel({
    required int id,
    @Default('') String name,
    @Default('') String address,
    @Default('') String image,
    double? distance,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'special_deal') @Default('') String specialDeal,
    @JsonKey(name: 'min_spend') @Default('') String minSpend,
    @JsonKey(name: 'nearest_merchant') MerchantModel? nearestMerchant,
  }) = _MerchantModel;

  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);

  String get distanceLabel =>
      distance != null ? '${distance!.toStringAsFixed(2)} km' : '';

  String get shortDistanceLabel {
    if (distance == null) return '';
    if (distance! < 1) {
      return '${(distance! * 1000).round()}m';
    }
    return distanceLabel;
  }
}

@freezed
abstract class MerchantListResponse with _$MerchantListResponse {
  const factory MerchantListResponse({
    @Default([]) List<MerchantModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _MerchantListResponse;

  factory MerchantListResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantListResponseFromJson(json);
}
