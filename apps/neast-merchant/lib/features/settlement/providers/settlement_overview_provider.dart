import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/settlement/models/settlement_overview_model.dart';
import 'package:neast/features/settlement/services/settlement_service.dart';

class SettlementOverviewNotifier
    extends AsyncNotifier<SettlementOverviewModel?> {
  @override
  Future<SettlementOverviewModel?> build() async {
    if (!ref.watch(authProvider)) {
      return null;
    }
    return ref.read(settlementServiceProvider).fetchOverview();
  }

  Future<bool> fetch({bool silent = false}) async {
    if (!ref.read(authProvider)) {
      return false;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(
      () => ref.read(settlementServiceProvider).fetchOverview(),
    );
    return state.hasValue && state.value != null;
  }
}

final settlementOverviewProvider = AsyncNotifierProvider<
    SettlementOverviewNotifier, SettlementOverviewModel?>(
  SettlementOverviewNotifier.new,
);
