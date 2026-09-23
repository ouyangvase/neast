import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/properties/models/property_model.dart';

class PropertyService {
  PropertyService(this._dioClient);

  final DioClient _dioClient;

  Future<PropertyListResponse> fetchList({
    required int page,
    required int limit,
  }) async {
    final response = await _dioClient.get(
      '/landlord/property/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    return PropertyListResponse.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  Future<PropertyModel> create({
    required String name,
    required String address,
    required String image,
    required String file,
  }) async {
    final response = await _dioClient.post(
      '/landlord/property/create',
      data: {
        'name': name,
        'address': address,
        'image': image,
        'file': file,
      },
    );

    return PropertyModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }
}

final propertyServiceProvider = Provider<PropertyService>((ref) {
  return PropertyService(ref.watch(dioClientProvider));
});
