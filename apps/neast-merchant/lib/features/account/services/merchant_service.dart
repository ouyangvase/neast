import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/account/models/merchant_info_model.dart';

class MerchantService {
  MerchantService(this._dioClient);

  final DioClient _dioClient;

  Future<MerchantInfoModel> fetchInfo() async {
    final response = await _dioClient.get('/merchant/info');
    return MerchantInfoModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

final merchantServiceProvider = Provider<MerchantService>((ref) {
  return MerchantService(ref.watch(dioClientProvider));
});
