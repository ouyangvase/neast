import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/services/location_service.dart';
import 'package:neast/features/home/models/home_dashboard_model.dart';
import 'package:neast/features/home/services/home_service.dart';

class HomeDashboardNotifier extends AsyncNotifier<HomeDashboardModel> {
  bool locationUnavailable = false;

  @override
  Future<HomeDashboardModel> build() async {
    return _fetchDashboard();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchDashboard);
  }

  Future<HomeDashboardModel> _fetchDashboard() async {
    locationUnavailable = false;
    double? latitude;
    double? longitude;

    try {
      final coords = await ref.read(currentLocationProvider.future);
      latitude = coords.latitude;
      longitude = coords.longitude;
    } on LocationUnavailableException {
      locationUnavailable = true;
    }

    return ref.read(homeServiceProvider).fetchDashboard(
          latitude: latitude,
          longitude: longitude,
        );
  }
}

final homeDashboardProvider =
    AsyncNotifierProvider<HomeDashboardNotifier, HomeDashboardModel>(
  HomeDashboardNotifier.new,
);
