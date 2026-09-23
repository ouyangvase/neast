import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/give_points/models/points_setting_model.dart';
import 'package:neast/features/give_points/services/points_setting_service.dart';

class PointsSettingNotifier extends AsyncNotifier<PointsSettingModel?> {
  @override
  Future<PointsSettingModel?> build() async {
    if (!ref.watch(authProvider)) {
      return null;
    }
    return ref.read(pointsSettingServiceProvider).fetchSetting();
  }

  Future<bool> fetch({bool silent = false}) async {
    if (!ref.read(authProvider)) {
      return false;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(
      () => ref.read(pointsSettingServiceProvider).fetchSetting(),
    );
    return state.hasValue && state.value != null;
  }
}

final pointsSettingProvider =
    AsyncNotifierProvider<PointsSettingNotifier, PointsSettingModel?>(
  PointsSettingNotifier.new,
);
