import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/utils/notifier_utils.dart';
import 'package:neast_landlords/features/account/models/landlord_info_model.dart';
import 'package:neast_landlords/features/account/services/landlord_service.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';

class LandlordInfoNotifier extends AsyncNotifier<LandlordInfoModel?> {
  bool _hasFetched = false;

  @override
  Future<LandlordInfoModel?> build() async => null;

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
      () => ref.read(landlordServiceProvider).fetchInfo(),
    );
    if (state.hasValue && state.value != null) {
      _hasFetched = true;
    }
  }

  Future<bool> deleteAccount() async {
    final deleted = await ref.runGuarded(() async {
      await ref.read(landlordServiceProvider).deleteAccount();
      return true;
    });
    if (deleted != true) {
      return false;
    }

    await ref.read(authProvider.notifier).logout();
    return true;
  }

  Future<bool> updateBankDetail({
    required String bankName,
    required String bankAccount,
    required String accountHolderName,
    required String bankHeaderPhoto,
  }) async {
    final updated = await ref.runGuarded(() async {
      await ref.read(landlordServiceProvider).updateBankDetail(
            bankName: bankName,
            bankAccount: bankAccount,
            accountHolderName: accountHolderName,
            bankHeaderPhoto: bankHeaderPhoto,
          );
      return true;
    });
    if (updated != true) {
      return false;
    }

    await refresh();
    return true;
  }
}

final landlordInfoProvider =
    AsyncNotifierProvider<LandlordInfoNotifier, LandlordInfoModel?>(
  LandlordInfoNotifier.new,
);
