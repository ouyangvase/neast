import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/transaction/models/transaction_record_model.dart';

class TransactionService {
  TransactionService(this._dioClient);

  final DioClient _dioClient;

  Future<List<TransactionRecord>> fetchRecords({
    required TransactionTab tab,
    required int year,
    required int page,
    required int pageSize,
  }) async {
    final path = tab == TransactionTab.points
        ? '/merchant/transaction/points'
        : '/merchant/transaction/redeemed';

    final response = await _dioClient.get(
      path,
      queryParameters: {
        'year': year,
        'page': page,
        'limit': pageSize,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? const [];

    return items.map((item) {
      final map = item as Map<String, dynamic>;
      return tab == TransactionTab.points
          ? TransactionRecord.fromPointsItem(
              TransactionPointsItemModel.fromJson(map),
            )
          : TransactionRecord.fromRedeemedItem(
              TransactionRedeemedItemModel.fromJson(map),
            );
    }).toList(growable: false);
  }
}

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(ref.watch(dioClientProvider));
});
