import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// 定位服务不可用（权限被拒或服务关闭）。
class LocationUnavailableException implements Exception {
  LocationUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LocationService {
  /// 获取当前位置，权限不足或服务关闭时抛出 [LocationUnavailableException]。
  Future<({double latitude, double longitude})> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationUnavailableException('Location services are disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw LocationUnavailableException('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationUnavailableException('Location permission permanently denied');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    return (latitude: position.latitude, longitude: position.longitude);
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// 当前定位（共享，仅取一次）。
///
/// 多个 Provider 共用同一个 future，避免并发调用 `getCurrentPosition()` 导致
/// 其中一个一直 pending。定位不可用时抛出 [LocationUnavailableException]。
final currentLocationProvider =
    FutureProvider<({double latitude, double longitude})>((ref) async {
  return ref.read(locationServiceProvider).getCurrentPosition();
});
