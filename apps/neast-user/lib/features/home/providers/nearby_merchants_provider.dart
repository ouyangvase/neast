import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/services/location_service.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/services/merchant_service.dart';

/// 首页「Nearby Merchants」分布图数据。
///
/// 包含定位中心点与附近（后端写死 20km 内）商家列表；定位不可用时仅置
/// [locationUnavailable]，由 UI 展示开启定位提示。
class NearbyMerchantsData {
  const NearbyMerchantsData({
    this.locationUnavailable = false,
    this.centerLat,
    this.centerLng,
    this.merchants = const [],
  });

  final bool locationUnavailable;
  final double? centerLat;
  final double? centerLng;
  final List<MerchantModel> merchants;
}

/// 拉取当前位置附近商家，供分布图使用（被 watch 时自动触发）。
final nearbyMerchantsProvider =
    FutureProvider<NearbyMerchantsData>((ref) async {
  final double latitude;
  final double longitude;
  try {
    final coords = await ref.watch(currentLocationProvider.future);
    latitude = coords.latitude;
    longitude = coords.longitude;
  } on LocationUnavailableException {
    return const NearbyMerchantsData(locationUnavailable: true);
  }

  final merchants = await ref.read(merchantServiceProvider).fetchNearby(
        latitude: latitude,
        longitude: longitude,
      );

  return NearbyMerchantsData(
    centerLat: latitude,
    centerLng: longitude,
    merchants: merchants,
  );
});
