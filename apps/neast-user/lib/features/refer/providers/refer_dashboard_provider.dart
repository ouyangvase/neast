import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/refer/models/refer_dashboard_model.dart';
import 'package:neast/features/refer/services/refer_service.dart';

class ReferDashboardNotifier extends AsyncNotifier<ReferDashboardModel> {
  @override
  Future<ReferDashboardModel> build() async {
    ref.keepAlive();
    return ref.read(referServiceProvider).fetchDashboard();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(referServiceProvider).fetchDashboard(),
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(referServiceProvider).fetchDashboard(),
    );
  }
}

final referDashboardProvider =
    AsyncNotifierProvider<ReferDashboardNotifier, ReferDashboardModel>(
  ReferDashboardNotifier.new,
);
