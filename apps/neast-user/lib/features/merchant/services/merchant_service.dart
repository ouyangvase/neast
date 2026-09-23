import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/merchant/models/merchant_category_model.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';

class MerchantService {
  MerchantService(this._dioClient);

  final DioClient _dioClient;

  Future<MerchantListResponse> fetchList({
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
    int? categoryId,
  }) async {
    return _fetchPaginatedList(
      '/app/merchant/list',
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
      categoryId: categoryId,
    );
  }

  Future<MerchantListResponse> fetchRecommendedList({
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
  }) async {
    return _fetchPaginatedList(
      '/app/merchant/recommended',
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
    );
  }

  Future<MerchantListResponse> fetchNearbyList({
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
    int? categoryId,
  }) async {
    return _fetchPaginatedList(
      '/app/merchant/nearby/list',
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
      categoryId: categoryId,
    );
  }

  /// 商家分类列表。
  Future<List<MerchantCategoryModel>> fetchCategories() async {
    final response = await _dioClient.get('/app/merchant/categories');
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) =>
            MerchantCategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<MerchantListResponse> _fetchPaginatedList(
    String path, {
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
    int? categoryId,
  }) async {
    final response = await _dioClient.get(
      path,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'page': page,
        'limit': limit,
        if (categoryId != null) 'category_id': categoryId,
      },
    );

    return MerchantListResponse.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  /// 商家详情。
  Future<MerchantModel> fetchDetail({
    required int id,
    double? latitude,
    double? longitude,
  }) async {
    final queryParameters = <String, dynamic>{'id': id};
    if (latitude != null) {
      queryParameters['latitude'] = latitude;
    }
    if (longitude != null) {
      queryParameters['longitude'] = longitude;
    }

    final response = await _dioClient.get(
      '/app/merchant/detail',
      queryParameters: queryParameters,
    );

    return MerchantModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  /// 附近商家（半径由后端写死），用于地图分布展示。
  Future<List<MerchantModel>> fetchNearby({
    required double latitude,
    required double longitude,
    int? categoryId,
  }) async {
    final response = await _dioClient.get(
      '/app/merchant/nearby',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        if (categoryId != null) 'category_id': categoryId,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    final items = (data['items'] as List).cast<Map<String, dynamic>>();
    return items.map(MerchantModel.fromJson).toList();
  }
}

final merchantServiceProvider = Provider<MerchantService>((ref) {
  return MerchantService(ref.watch(dioClientProvider));
});
