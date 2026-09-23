import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/daily_closing/models/daily_closing_summary_model.dart';
import 'package:neast/features/daily_closing/models/daily_closing_transaction_model.dart';

class DailyClosingService {
  DailyClosingService(this._dioClient);

  final DioClient _dioClient;

  Future<DailyClosingSummaryModel> fetchSummary() async {
    final response = await _dioClient.get('/merchant/daily-closing/summary');
    return DailyClosingSummaryModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  Future<List<DailyClosingTransactionModel>> fetchTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      '/merchant/daily-closing/transactions',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? const [];

    return items
        .map(
          (item) => DailyClosingTransactionModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList(growable: false);
  }
}

final dailyClosingServiceProvider = Provider<DailyClosingService>((ref) {
  return DailyClosingService(ref.watch(dioClientProvider));
});
