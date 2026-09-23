import 'dart:async';

import 'package:flutter/foundation.dart';
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

    if (kDebugMode) {
      return (latitude: 1.4862, longitude: 103.6565);
    }

    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      return (latitude: lastKnown.latitude, longitude: lastKnown.longitude);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
      return (latitude: position.latitude, longitude: position.longitude);
    } on TimeoutException {
      final timedOutLastKnown = await Geolocator.getLastKnownPosition();
      if (timedOutLastKnown != null) {
        return (
          latitude: timedOutLastKnown.latitude,
          longitude: timedOutLastKnown.longitude,
        );
      }
      throw LocationUnavailableException('Location request timed out');
    }
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
