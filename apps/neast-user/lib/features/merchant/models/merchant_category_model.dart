import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_category_model.freezed.dart';
part 'merchant_category_model.g.dart';

@freezed
abstract class MerchantCategoryModel with _$MerchantCategoryModel {
  const factory MerchantCategoryModel({
    required int id,
    @Default('') String name,
  }) = _MerchantCategoryModel;

  factory MerchantCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantCategoryModelFromJson(json);
}

@freezed
abstract class MerchantCategoryListResponse with _$MerchantCategoryListResponse {
  const factory MerchantCategoryListResponse({
    @Default([]) List<MerchantCategoryModel> items,
  }) = _MerchantCategoryListResponse;

  factory MerchantCategoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantCategoryListResponseFromJson(json);
}
