import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/features/home/models/home_dashboard_model.dart';
import 'package:neast_landlords/features/home/services/home_service.dart';

class HomeDashboardNotifier extends AsyncNotifier<HomeDashboardModel?> {
  @override
  Future<HomeDashboardModel?> build() async {
    if (!ref.watch(authProvider)) {
      return null;
    }
    return ref.read(homeServiceProvider).fetchDashboard();
  }

  Future<void> refresh() async {
    if (!ref.read(authProvider)) {
      return;
    }
    state = await AsyncValue.guard(
      () => ref.read(homeServiceProvider).fetchDashboard(),
    );
  }
}

final homeDashboardProvider =
    AsyncNotifierProvider<HomeDashboardNotifier, HomeDashboardModel?>(
  HomeDashboardNotifier.new,
);
