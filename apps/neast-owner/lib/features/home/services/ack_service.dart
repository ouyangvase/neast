import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/home/models/ack_item_model.dart';

class AckService {
  AckService(this._dioClient);

  final DioClient _dioClient;

  Future<List<AckItemModel>> fetchList() async {
    final response = await _dioClient.get('/landlord/ack/list');
    final data = Map<String, dynamic>.from(response['data'] as Map);
    final rawItems = data['items'];

    if (rawItems is! List) {
      return const [];
    }

    return rawItems
        .whereType<Map>()
        .map((item) => AckItemModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> confirm({required int id}) async {
    await _dioClient.post(
      '/landlord/ack/confirm',
      data: {'id': id},
    );
  }
}

final ackServiceProvider = Provider<AckService>((ref) {
  return AckService(ref.watch(dioClientProvider));
});
