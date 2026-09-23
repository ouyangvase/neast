import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/daily_closing/models/daily_closing_transaction_model.dart';
import 'package:neast/features/daily_closing/services/daily_closing_service.dart';

class DailyClosingTransactionListNotifier
    extends PaginatedListNotifier<DailyClosingTransactionModel> {
  @override
  int get initialPageSize => 20;

  @override
  Future<List<DailyClosingTransactionModel>> fetchPage(
    int page,
    int pageSize,
  ) {
    return ref.read(dailyClosingServiceProvider).fetchTransactions(
          page: page,
          limit: pageSize,
        );
  }
}

final dailyClosingTransactionListProvider = NotifierProvider<
    DailyClosingTransactionListNotifier,
    PaginatedListState<DailyClosingTransactionModel>>(
  DailyClosingTransactionListNotifier.new,
);
