import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_family_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/transaction/models/transaction_record_model.dart';
import 'package:neast/features/transaction/services/transaction_service.dart';

/// family 入参：Tab + 年份。不同组合 = 不同列表实例（各自分页）。
typedef TransactionListArg = ({TransactionTab tab, int year});

class TransactionListNotifier
    extends PaginatedListFamilyNotifier<TransactionRecord, TransactionListArg> {
  TransactionListNotifier(super.arg);

  @override
  Future<List<TransactionRecord>> fetchPage(int page, int pageSize) {
    return ref.read(transactionServiceProvider).fetchRecords(
          tab: arg.tab,
          year: arg.year,
          page: page,
          pageSize: pageSize,
        );
  }
}

final transactionListProvider = NotifierProvider.family<TransactionListNotifier,
    PaginatedListState<TransactionRecord>, TransactionListArg>(
  TransactionListNotifier.new,
);
