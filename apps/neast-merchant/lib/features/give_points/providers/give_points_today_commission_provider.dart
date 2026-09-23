import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/give_points/models/give_points_today_commission_model.dart';
import 'package:neast/features/give_points/services/give_points_service.dart';

class GivePointsTodayCommissionNotifier
    extends AsyncNotifier<GivePointsTodayCommissionModel?> {
  @override
  Future<GivePointsTodayCommissionModel?> build() async {
    if (!ref.watch(authProvider)) {
      return null;
    }
    return ref.read(givePointsServiceProvider).fetchTodayCommission();
  }

  Future<bool> fetch({bool silent = false}) async {
    if (!ref.read(authProvider)) {
      return false;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(
      () => ref.read(givePointsServiceProvider).fetchTodayCommission(),
    );
    return state.hasValue && state.value != null;
  }
}

final givePointsTodayCommissionProvider = AsyncNotifierProvider<
    GivePointsTodayCommissionNotifier, GivePointsTodayCommissionModel?>(
  GivePointsTodayCommissionNotifier.new,
);
