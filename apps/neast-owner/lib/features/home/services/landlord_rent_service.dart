import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/home/models/landlord_rent_detail_model.dart';

class LandlordRentService {
  LandlordRentService(this._dioClient);

  final DioClient _dioClient;

  Future<LandlordRentDetailModel> fetchDetail(int id) async {
    final response = await _dioClient.get('/landlord/rent/id/$id');
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return LandlordRentDetailModel.fromJson(data);
  }

  Future<void> terminateRent(int id, {String? reason}) async {
    final data = <String, dynamic>{};
    if (reason != null && reason.isNotEmpty) {
      data['reason'] = reason;
    }

    await _dioClient.put(
      '/landlord/rent/id/$id/terminate',
      data: data,
    );
  }
}

final landlordRentServiceProvider = Provider<LandlordRentService>((ref) {
  return LandlordRentService(ref.watch(dioClientProvider));
});
