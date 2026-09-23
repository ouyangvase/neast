import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:neast_landlords/core/constants/app_constants.dart';
import 'package:neast_landlords/core/pagination/paginated_list_family_notifier.dart';
import 'package:neast_landlords/core/pagination/paginated_list_state.dart';
import 'package:neast_landlords/features/records/models/record_item_model.dart';
import 'package:neast_landlords/features/records/services/record_service.dart';

typedef RecordListArg = ({int year, int month});

class RecordListNotifier
    extends PaginatedListFamilyNotifier<RecordItemModel, RecordListArg> {
  RecordListNotifier(super.arg);

  @override
  int get initialPageSize => AppConstants.defaultPageSize;

  @override
  Future<List<RecordItemModel>> fetchPage(int page, int pageSize) async {
    final response = await ref.read(recordServiceProvider).fetchList(
          year: arg.year,
          month: arg.month,
          page: page,
          limit: pageSize,
        );
    ref.read(recordAmountSumProvider.notifier).state = response.amountSum;
    return response.items;
  }
}

final recordListProvider = NotifierProvider.family<
    RecordListNotifier,
    PaginatedListState<RecordItemModel>,
    RecordListArg>(RecordListNotifier.new);

final recordAmountSumProvider = StateProvider<String>((ref) => '0');
