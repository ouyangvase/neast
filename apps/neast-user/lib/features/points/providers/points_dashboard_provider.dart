import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/points/models/points_dashboard_model.dart';
import 'package:neast/features/points/services/points_service.dart';

class PointsDashboardNotifier extends AsyncNotifier<PointsDashboardModel> {
  @override
  Future<PointsDashboardModel> build() async {
    ref.keepAlive();
    return ref.read(pointsServiceProvider).fetchDashboard();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(pointsServiceProvider).fetchDashboard(),
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(pointsServiceProvider).fetchDashboard(),
    );
  }
}

final pointsDashboardProvider =
    AsyncNotifierProvider<PointsDashboardNotifier, PointsDashboardModel>(
  PointsDashboardNotifier.new,
);
