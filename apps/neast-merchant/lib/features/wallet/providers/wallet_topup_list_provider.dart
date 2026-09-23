import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/wallet/models/wallet_topup_model.dart';
import 'package:neast/features/wallet/services/wallet_service.dart';

class WalletTopupListNotifier extends PaginatedListNotifier<WalletTopupModel> {
  @override
  int get initialPageSize => 10;

  @override
  Future<List<WalletTopupModel>> fetchPage(int page, int pageSize) {
    return ref.read(walletServiceProvider).fetchTopupList(
          page: page,
          limit: pageSize,
        );
  }
}

final walletTopupListProvider = NotifierProvider<
    WalletTopupListNotifier,
    PaginatedListState<WalletTopupModel>>(
  WalletTopupListNotifier.new,
);
