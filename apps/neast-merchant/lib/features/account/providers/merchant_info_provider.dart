import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/account/models/merchant_info_model.dart';
import 'package:neast/features/account/services/merchant_service.dart';

class MerchantInfoNotifier extends AsyncNotifier<MerchantInfoModel?> {
  bool _hasFetched = false;

  @override
  Future<MerchantInfoModel?> build() async => null;

  Future<void> fetchIfNeeded() async {
    if (_hasFetched && state.hasValue && state.value != null) {
      return;
    }
    await _load();
  }

  Future<void> refresh() async {
    await _load(force: true);
  }

  void clear() {
    _hasFetched = false;
    state = const AsyncData(null);
  }

  Future<void> _load({bool force = false}) async {
    if (force) {
      _hasFetched = false;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(merchantServiceProvider).fetchInfo(),
    );
    if (state.hasValue && state.value != null) {
      _hasFetched = true;
    }
  }
}

final merchantInfoProvider =
    AsyncNotifierProvider<MerchantInfoNotifier, MerchantInfoModel?>(
  MerchantInfoNotifier.new,
);
