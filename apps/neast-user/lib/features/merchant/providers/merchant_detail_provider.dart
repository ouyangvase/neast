import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/services/location_service.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/services/merchant_service.dart';

/// 商家详情（按 id 缓存，进入页面时后台刷新）。
final merchantDetailProvider = NotifierProvider.family<
    MerchantDetailNotifier,
    AsyncValue<MerchantModel>,
    int>(
  MerchantDetailNotifier.new,
);

class MerchantDetailNotifier extends Notifier<AsyncValue<MerchantModel>> {
  MerchantDetailNotifier(this.merchantId);

  final int merchantId;

  @override
  AsyncValue<MerchantModel> build() {
    ref.keepAlive();
    return const AsyncLoading();
  }

  /// 进入详情页时调用：有缓存则先展示，同时请求最新数据。
  Future<void> refresh() async {
    final cached = state.asData?.value;
    if (cached == null) {
      state = const AsyncLoading();
    }

    try {
      final merchant = await _fetchDetail();
      state = AsyncData(merchant);
    } catch (error, stackTrace) {
      if (cached != null) {
        state = AsyncData(cached);
      } else {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  Future<MerchantModel> _fetchDetail() async {
    double? latitude;
    double? longitude;

    try {
      final coords = await ref.read(currentLocationProvider.future);
      latitude = coords.latitude;
      longitude = coords.longitude;
    } on LocationUnavailableException {
      // 定位不可用时仍加载详情，distance 由后端返回 null
    }

    return ref.read(merchantServiceProvider).fetchDetail(
          id: merchantId,
          latitude: latitude,
          longitude: longitude,
        );
  }
}
