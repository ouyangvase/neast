import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:neast/core/pagination/paginated_list_family_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';

/// Pay Rent 页底部最近 5 条还款历史。
final payRentRecentHistoryProvider =
    FutureProvider.autoDispose<List<RentHistoryModel>>((ref) async {
  final response = await ref.read(rentServiceProvider).fetchHistoryList(
        page: 1,
        limit: 5,
      );
  return response.items;
});

/// History Tab 当前选中年份，`null` 表示全部。
final rentHistoryYearProvider = StateProvider<int?>((ref) => null);

class RentHistoryListNotifier
    extends PaginatedListFamilyNotifier<RentHistoryModel, int?> {
  RentHistoryListNotifier(super.arg);

  @override
  int get initialPageSize => 15;

  @override
  Future<List<RentHistoryModel>> fetchPage(int page, int pageSize) async {
    final response = await ref.read(rentServiceProvider).fetchHistoryList(
          page: page,
          limit: pageSize,
          year: arg,
        );
    return response.items;
  }
}

/// History Tab 分页列表（family：`int?` 为年份筛选）。
final rentHistoryListProvider = NotifierProvider.family<
    RentHistoryListNotifier,
    PaginatedListState<RentHistoryModel>,
    int?>(RentHistoryListNotifier.new);
