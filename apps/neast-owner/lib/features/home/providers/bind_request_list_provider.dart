import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/features/home/models/bind_request_item_model.dart';
import 'package:neast_landlords/features/home/services/bind_request_service.dart';

class BindRequestListNotifier extends AsyncNotifier<List<BindRequestItemModel>> {
  @override
  Future<List<BindRequestItemModel>> build() async {
    if (!ref.watch(authProvider)) {
      return const [];
    }
    return ref.read(bindRequestServiceProvider).fetchList();
  }

  Future<void> refresh() async {
    if (!ref.read(authProvider)) {
      return;
    }
    state = await AsyncValue.guard(
      () => ref.read(bindRequestServiceProvider).fetchList(),
    );
  }
}

final bindRequestListProvider =
    AsyncNotifierProvider<BindRequestListNotifier, List<BindRequestItemModel>>(
  BindRequestListNotifier.new,
);
