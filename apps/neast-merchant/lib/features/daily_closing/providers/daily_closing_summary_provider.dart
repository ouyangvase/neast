import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/daily_closing/models/daily_closing_summary_model.dart';
import 'package:neast/features/daily_closing/services/daily_closing_service.dart';

class DailyClosingSummaryNotifier
    extends AsyncNotifier<DailyClosingSummaryModel?> {
  @override
  Future<DailyClosingSummaryModel?> build() async {
    if (!ref.watch(authProvider)) {
      return null;
    }
    return ref.read(dailyClosingServiceProvider).fetchSummary();
  }

  Future<bool> fetch({bool silent = false}) async {
    if (!ref.read(authProvider)) {
      return false;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(
      () => ref.read(dailyClosingServiceProvider).fetchSummary(),
    );
    return state.hasValue && state.value != null;
  }
}

final dailyClosingSummaryProvider = AsyncNotifierProvider<
    DailyClosingSummaryNotifier, DailyClosingSummaryModel?>(
  DailyClosingSummaryNotifier.new,
);
