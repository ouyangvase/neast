import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/home/models/bind_request_item_model.dart';

class BindRequestService {
  BindRequestService(this._dioClient);

  final DioClient _dioClient;

  Future<List<BindRequestItemModel>> fetchList() async {
    final response = await _dioClient.get('/landlord/bind-request/list');
    final data = Map<String, dynamic>.from(response['data'] as Map);
    final rawItems = data['items'];

    if (rawItems is! List) {
      return const [];
    }

    return rawItems
        .whereType<Map>()
        .map(
          (item) => BindRequestItemModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<void> audit({
    required int id,
    required String result,
  }) async {
    await _dioClient.post(
      '/landlord/bind-request/audit',
      data: {
        'id': id,
        'result': result,
      },
    );
  }
}

final bindRequestServiceProvider = Provider<BindRequestService>((ref) {
  return BindRequestService(ref.watch(dioClientProvider));
});
