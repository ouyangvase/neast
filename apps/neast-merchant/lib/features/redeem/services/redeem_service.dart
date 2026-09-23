import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/redeem/models/redeem_voucher_preview_model.dart';

class RedeemService {
  RedeemService(this._dioClient);

  final DioClient _dioClient;

  Future<RedeemVoucherPreviewModel> verifyByCode(String code) async {
    final response = await _dioClient.post(
      '/merchant/coupon/verify',
      data: {'code': code},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RedeemVoucherPreviewModel.fromJson(data);
  }

  Future<RedeemVoucherPreviewModel> redeemByCode(String code) async {
    final response = await _dioClient.post(
      '/merchant/coupon/redeem',
      data: {'code': code},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};

    return RedeemVoucherPreviewModel.fromJson(data);
  }
}

final redeemServiceProvider = Provider<RedeemService>((ref) {
  return RedeemService(ref.watch(dioClientProvider));
});
