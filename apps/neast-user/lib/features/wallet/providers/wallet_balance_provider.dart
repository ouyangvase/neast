import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/wallet/services/wallet_service.dart';

class WalletBalanceNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async => '0.00';

  Future<void> silentRefresh() async {
    final hadValue = state.hasValue;
    if (!hadValue) {
      state = const AsyncLoading();
    }

    final next = await AsyncValue.guard(
      () => ref.read(walletServiceProvider).fetchBalance(),
    );

    if (next.hasValue) {
      state = next;
    } else if (!hadValue) {
      state = next;
    }
  }
}

final walletBalanceProvider =
    AsyncNotifierProvider<WalletBalanceNotifier, String>(
  WalletBalanceNotifier.new,
);
