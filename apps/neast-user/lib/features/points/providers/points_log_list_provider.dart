import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/features/points/models/points_log_model.dart';
import 'package:neast/features/points/services/points_service.dart';

class PointsLogListNotifier extends PaginatedListNotifier<PointsLogModel> {
  @override
  int get initialPageSize => 15;

  @override
  Future<List<PointsLogModel>> fetchPage(int page, int pageSize) {
    return ref.read(pointsServiceProvider).fetchLogs(
          page: page,
          limit: pageSize,
        );
  }
}

final pointsLogListProvider = NotifierProvider<
    PointsLogListNotifier,
    PaginatedListState<PointsLogModel>>(
  PointsLogListNotifier.new,
);
