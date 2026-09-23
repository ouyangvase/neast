import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/rich_text/models/agreement_model.dart';

class AgreementService {
  AgreementService(this._dioClient);

  final DioClient _dioClient;

  Future<AgreementModel?> fetchByTitle(String title) async {
    final response = await _dioClient.get(
      '/merchant/agreement/detail',
      queryParameters: {'title': title},
    );

    final data = response['data'];
    if (data == null) {
      return null;
    }
    if (data is! Map) {
      return null;
    }

    return AgreementModel.fromJson(Map<String, dynamic>.from(data));
  }
}

final agreementServiceProvider = Provider<AgreementService>((ref) {
  return AgreementService(ref.watch(dioClientProvider));
});
