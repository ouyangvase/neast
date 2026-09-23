import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/features/home/models/ack_item_model.dart';
import 'package:neast_landlords/features/home/services/ack_service.dart';

class AckListNotifier extends AsyncNotifier<List<AckItemModel>> {
  @override
  Future<List<AckItemModel>> build() async {
    if (!ref.watch(authProvider)) {
      return const [];
    }
    return ref.read(ackServiceProvider).fetchList();
  }

  Future<void> refresh() async {
    if (!ref.read(authProvider)) {
      return;
    }
    state = await AsyncValue.guard(
      () => ref.read(ackServiceProvider).fetchList(),
    );
  }
}

final ackListProvider =
    AsyncNotifierProvider<AckListNotifier, List<AckItemModel>>(
  AckListNotifier.new,
);
