import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/models/rent_property_model.dart';

class RentService {
  RentService(this._dioClient);

  final DioClient _dioClient;

  Future<RentListResponse> fetchList({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      '/app/rent/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RentListResponse.fromJson(data);
  }

  Future<RentPropertyModel> fetchPropertyBySn(String sn) async {
    final response = await _dioClient.get(
      '/app/rent/property',
      queryParameters: {'sn': sn},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RentPropertyModel.fromJson(data);
  }

  Future<RentModel> create({
    required double amount,
    required String file,
    required int paidAt,
    required String firstPayMonth,
    required int leaseMonths,
    required String propertyName,
    int? propertyId,
    String? ownerName,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
      'file': file,
      'paid_at': paidAt,
      'first_pay_month': firstPayMonth,
      'lease_months': leaseMonths,
      'property_name': propertyName,
    };
    if (propertyId != null && propertyId > 0) {
      body['property_id'] = propertyId;
    } else if (ownerName != null && ownerName.isNotEmpty) {
      body['owner_name'] = ownerName;
    }

    final response = await _dioClient.post(
      '/app/rent/create',
      data: body,
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RentModel.fromJson(data);
  }

  Future<RentHistoryListResponse> fetchHistoryList({
    int page = 1,
    int limit = 15,
    int? year,
    int? rentId,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (year != null) {
      queryParameters['year'] = year;
    }
    if (rentId != null) {
      queryParameters['rent_id'] = rentId;
    }

    final response = await _dioClient.get(
      '/app/rent/history/list',
      queryParameters: queryParameters,
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RentHistoryListResponse.fromJson(data);
  }

  Future<List<RentHistoryModel>> fetchHistoryByRentId(int rentId) async {
    final response = await fetchHistoryList(
      page: 1,
      limit: 100,
      rentId: rentId,
    );
    return response.items;
  }

  Future<List<RentPropertyModel>> fetchConnectOptions() async {
    final response = await _dioClient.get('/app/rent/connect-options');
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .whereType<Map>()
        .map(
          (item) => RentPropertyModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> inviteOwner({
    required int rentId,
    required int historyId,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _dioClient.post(
      '/app/rent/invite',
      data: {
        'rent_id': rentId,
        'history_id': historyId,
        'name': name,
        'email': email,
        'phone': phone,
      },
    );
  }

  Future<RentHistoryModel> payByWallet({
    required int rentId,
    required String paymentMethod,
    String? ownerBankName,
    String? ownerBankAccount,
    String? ownerAccountHolder,
  }) async {
    final response = await _dioClient.post(
      '/app/rent/pay/wallet',
      data: {
        'rent_id': rentId,
        'payment_method': paymentMethod,
        if (ownerBankName != null && ownerBankName.isNotEmpty)
          'owner_bank_name': ownerBankName,
        if (ownerBankAccount != null && ownerBankAccount.isNotEmpty)
          'owner_bank_account': ownerBankAccount,
        if (ownerAccountHolder != null && ownerAccountHolder.isNotEmpty)
          'owner_account_holder': ownerAccountHolder,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RentHistoryModel.fromJson(data);
  }

  Future<RentPayOrder> createPayOrder({
    required int rentId,
    required String paymentMethod,
    String? paymentChannel,
    String? ownerBankName,
    String? ownerBankAccount,
    String? ownerAccountHolder,
  }) async {
    final payload = <String, dynamic>{
      'rent_id': rentId,
      'payment_method': paymentMethod,
    };
    if (paymentChannel != null && paymentChannel.isNotEmpty) {
      payload['payment_channel'] = paymentChannel;
    }
    if (ownerBankName != null && ownerBankName.isNotEmpty) {
      payload['owner_bank_name'] = ownerBankName;
    }
    if (ownerBankAccount != null && ownerBankAccount.isNotEmpty) {
      payload['owner_bank_account'] = ownerBankAccount;
    }
    if (ownerAccountHolder != null && ownerAccountHolder.isNotEmpty) {
      payload['owner_account_holder'] = ownerAccountHolder;
    }

    final response = await _dioClient.post(
      '/app/rent/pay/create',
      data: payload,
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RentPayOrder.fromJson(data);
  }

  Future<void> terminateRent(int id, {String? reason}) async {
    final data = <String, dynamic>{};
    if (reason != null && reason.isNotEmpty) {
      data['reason'] = reason;
    }

    await _dioClient.put(
      '/app/rent/id/$id/terminate',
      data: data,
    );
  }
}

final rentServiceProvider = Provider<RentService>((ref) {
  return RentService(ref.watch(dioClientProvider));
});
