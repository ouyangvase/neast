import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// 地图瓦片与视窗配置。
class MapTileConfig {
  MapTileConfig._();

  static const userAgentPackageName = 'com.neastusers.flutter';
  static const osmUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// 默认视窗半径（km），地图宽度方向约覆盖 2 倍半径。
  static const defaultViewportRadiusKm = 30.0;

  static const minZoom = 3.0;
  static const maxZoom = 18.0;

  /// 默认交互：关闭 fling，规避 8.3.x 已知 NaN 崩溃（#2221 / #2227）。
  static const interactionOptions = InteractionOptions(
    flags: InteractiveFlag.all &
        ~InteractiveFlag.doubleTapZoom &
        ~InteractiveFlag.flingAnimation,
  );

  /// 与 flutter_map 官方 example 一致：仅 urlTemplate + userAgentPackageName。
  static TileLayer buildOsmTileLayer() {
    return TileLayer(
      urlTemplate: osmUrlTemplate,
      userAgentPackageName: userAgentPackageName,
    );
  }

  /// 以 [center] 为中心、约 [radiusKm] 为半径的视窗边界。
  static LatLngBounds boundsForRadiusKm(LatLng center, double radiusKm) {
    const kmPerDegreeLat = 111.32;
    final latDelta = radiusKm / kmPerDegreeLat;
    final cosLat =
        math.cos(center.latitude * math.pi / 180).abs().clamp(0.01, 1.0);
    final lngDelta = radiusKm / (kmPerDegreeLat * cosLat);

    return LatLngBounds(
      LatLng(center.latitude - latDelta, center.longitude - lngDelta),
      LatLng(center.latitude + latDelta, center.longitude + lngDelta),
    );
  }

  /// 按视窗宽度与目标半径（km）计算 Web Mercator 缩放级别。
  static double zoomForRadiusKm({
    required double latitude,
    required double radiusKm,
    required double mapWidthPx,
  }) {
    if (mapWidthPx <= 0 || radiusKm <= 0) {
      return 10;
    }

    final diameterMeters = radiusKm * 2 * 1000;
    final cosLat = math.cos(latitude * math.pi / 180);
    final zoom = math.log(156543.03392 * cosLat * mapWidthPx / diameterMeters) /
        math.ln2;

    return zoom.clamp(minZoom, maxZoom);
  }
}
