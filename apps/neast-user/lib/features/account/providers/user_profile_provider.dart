import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/account/models/user_profile_model.dart';
import 'package:neast/features/account/services/user_service.dart';
import 'package:neast/features/auth/services/auth_service.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfileModel?> {
  bool _hasFetched = false;

  @override
  Future<UserProfileModel?> build() async => null;

  Future<void> fetchIfNeeded() async {
    if (_hasFetched && state.hasValue && state.value != null) {
      return;
    }
    await _load();
  }

  Future<void> refresh() async {
    await _load();
  }

  void clear() {
    _hasFetched = false;
    state = const AsyncData(null);
  }

  Future<void> _load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userServiceProvider).fetchProfile(),
    );
    if (state.hasValue && state.value != null) {
      _hasFetched = true;
    }
  }

  Future<bool> deleteAccount() async {
    final deleted = await ref.runGuarded(() async {
      await ref.read(userServiceProvider).deleteAccount();
      return true;
    });
    if (deleted != true) {
      return false;
    }

    await ref.read(authProvider.notifier).logout();
    return true;
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfileModel?>(
  UserProfileNotifier.new,
);
