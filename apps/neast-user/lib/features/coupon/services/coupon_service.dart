import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/coupon/models/coupon_category_model.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/models/coupon_model.dart';

class CouponService {
  CouponService(this._dioClient);

  final DioClient _dioClient;

  /// 优惠券分类列表。
  Future<List<CouponCategoryModel>> fetchCategories() async {
    final response = await _dioClient.get('/app/coupon/categories');
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => CouponCategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 优惠券列表（categoryId 为空表示全部）。
  Future<List<CouponListItemModel>> fetchList({
    int? categoryId,
    required int page,
    required int limit,
  }) async {
    final response = await _dioClient.get(
      '/app/coupon/list',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (categoryId != null) 'category_id': categoryId,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => CouponListItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 商家可用优惠券列表。
  Future<List<CouponListItemModel>> fetchListByMerchant(int merchantId) async {
    final response = await _dioClient.get(
      '/app/coupon/merchant-list',
      queryParameters: {'merchant_id': merchantId},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => CouponListItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 我的未使用优惠券数量。
  Future<int> fetchMyCount() async {
    final response = await _dioClient.get('/app/coupon/my-count');
    final data = response['data'] as Map<String, dynamic>? ?? {};
    return data['count'] as int? ?? 0;
  }

  /// 我的优惠券列表（按状态筛选）。
  Future<List<CouponListItemModel>> fetchMyList({
    required MyVoucherStatus status,
    required int page,
    required int limit,
  }) async {
    final response = await _dioClient.get(
      '/app/coupon/my-list',
      queryParameters: {
        'page': page,
        'limit': limit,
        'status': status.name,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => CouponListItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 最新优惠券（首页 Featured 展示）。
  Future<CouponModel?> fetchLatest() async {
    final response = await _dioClient.get('/app/coupon/latest');
    final data = response['data'];
    if (data == null) {
      return null;
    }

    return CouponModel.fromJson(data as Map<String, dynamic>);
  }

  /// 兑换优惠券，返回更新后的列表项。
  Future<CouponListItemModel> redeem(int couponId) async {
    final response = await _dioClient.post(
      '/app/coupon/redeem',
      data: {'coupon_id': couponId},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final item = data['item'] as Map<String, dynamic>? ?? {};

    return CouponListItemModel.fromJson(item);
  }
}

final couponServiceProvider = Provider<CouponService>((ref) {
  return CouponService(ref.watch(dioClientProvider));
});
