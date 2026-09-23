import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/wallet/models/wallet_topup_model.dart';
import 'package:neast/features/wallet/services/wallet_service.dart';
import 'package:neast/features/wallet/utils/wallet_topup_month_util.dart';

class WalletTopupListNotifier extends PaginatedListNotifier<WalletTopupModel> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  DateTime get selectedMonth => _selectedMonth;

  String get monthLabel => formatWalletTopupMonthLabel(_selectedMonth);

  @override
  int get initialPageSize => 10;

  Future<void> setMonth(DateTime month) async {
    final normalized = DateTime(month.year, month.month);
    if (normalized.year == _selectedMonth.year &&
        normalized.month == _selectedMonth.month) {
      return;
    }
    await applyFilter(() => _selectedMonth = normalized);
  }

  @override
  Future<List<WalletTopupModel>> fetchPage(int page, int pageSize) {
    return ref.read(walletServiceProvider).fetchTopupList(
          page: page,
          limit: pageSize,
          year: _selectedMonth.year,
          month: _selectedMonth.month,
        );
  }
}

final walletTopupListProvider = NotifierProvider<
    WalletTopupListNotifier,
    PaginatedListState<WalletTopupModel>>(
  WalletTopupListNotifier.new,
);
