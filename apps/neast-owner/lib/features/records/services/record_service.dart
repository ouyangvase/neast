import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/records/models/record_item_model.dart';

class RecordService {
  RecordService(this._dioClient);

  final DioClient _dioClient;

  Future<RecordListResponse> fetchList({
    required int year,
    required int month,
    required int page,
    required int limit,
  }) async {
    final response = await _dioClient.get(
      '/landlord/record/list',
      queryParameters: {
        'year': year,
        'month': month,
        'page': page,
        'limit': limit,
      },
    );

    return RecordListResponse.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }
}

final recordServiceProvider = Provider<RecordService>((ref) {
  return RecordService(ref.watch(dioClientProvider));
});
