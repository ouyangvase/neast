import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:neast/core/constants/map_tile_config.dart';
import 'package:neast/core/services/location_service.dart';

/// 临时调试页：仅地图，对齐 flutter_map 官方 MarkerPage 写法。
/// 验证通过后改回 [MerchantMapScreen]。
class MerchantMapDemoScreen extends ConsumerWidget {
  const MerchantMapDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Demo'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '当前定位为中心，视窗约 ${MapTileConfig.defaultViewportRadiusKm.toInt()}km\n'
              'zoom 限制 ${MapTileConfig.minZoom.toInt()}-${MapTileConfig.maxZoom.toInt()}，请快速缩小测试',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withValues(alpha: 0.65),
              ),
            ),
          ),
          Flexible(
            child: locationAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    error is LocationUnavailableException
                        ? error.message
                        : 'Failed to get current location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
              data: (coords) => _MapDemoView(
                center: LatLng(coords.latitude, coords.longitude),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapDemoView extends StatelessWidget {
  const _MapDemoView({required this.center});

  final LatLng center;

  @override
  Widget build(BuildContext context) {
    final viewportBounds = MapTileConfig.boundsForRadiusKm(
      center,
      MapTileConfig.defaultViewportRadiusKm,
    );

    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: viewportBounds,
          minZoom: MapTileConfig.minZoom,
          maxZoom: MapTileConfig.maxZoom,
        ),
        minZoom: MapTileConfig.minZoom,
        maxZoom: MapTileConfig.maxZoom,
        interactionOptions: MapTileConfig.interactionOptions,
      ),
      children: [
        MapTileConfig.buildOsmTileLayer(),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 60,
              height: 60,
              child: const Icon(
                Icons.my_location,
                size: 36,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
