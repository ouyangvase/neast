import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/services/location_service.dart';
import 'package:neast/features/reward/models/reward_dashboard_model.dart';
import 'package:neast/features/reward/services/reward_service.dart';

class RewardDashboardNotifier extends AsyncNotifier<RewardDashboardModel> {
  bool locationUnavailable = false;

  @override
  Future<RewardDashboardModel> build() async {
    ref.keepAlive();
    return _fetchDashboard();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchDashboard);
  }

  /// 下拉刷新（保留当前数据，不进入全页 loading）
  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetchDashboard);
  }

  Future<RewardDashboardModel> _fetchDashboard() async {
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

    return ref.read(rewardServiceProvider).fetchDashboard(
          latitude: latitude,
          longitude: longitude,
        );
  }
}

final rewardDashboardProvider =
    AsyncNotifierProvider<RewardDashboardNotifier, RewardDashboardModel>(
  RewardDashboardNotifier.new,
);
