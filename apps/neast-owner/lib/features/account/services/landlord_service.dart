import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/account/models/landlord_info_model.dart';

class LandlordService {
  LandlordService(this._dioClient);

  final DioClient _dioClient;

  Future<LandlordInfoModel> fetchInfo() async {
    final response = await _dioClient.get('/landlord/info');
    return LandlordInfoModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> deleteAccount() async {
    await _dioClient.post('/landlord/delete-account');
  }

  Future<void> updateBankDetail({
    required String bankName,
    required String bankAccount,
    required String accountHolderName,
    required String bankHeaderPhoto,
  }) async {
    await _dioClient.post('/landlord/bank-detail', data: {
      'bank_name': bankName,
      'bank_account': bankAccount,
      'account_holder_name': accountHolderName,
      'bank_header_photo': bankHeaderPhoto,
    });
  }
}

final landlordServiceProvider = Provider<LandlordService>((ref) {
  return LandlordService(ref.watch(dioClientProvider));
});
