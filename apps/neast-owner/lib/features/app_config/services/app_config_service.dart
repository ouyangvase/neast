import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/network/dio_client.dart';
import 'package:neast_landlords/features/app_config/models/app_config_model.dart';

class AppConfigService {
  AppConfigService(this._dioClient);

  final DioClient _dioClient;

  Future<AppConfigModel> fetch() async {
    final response = await _dioClient.get('/landlord/config');
    final data = response['data'];
    if (data is! Map) {
      return const AppConfigModel(showAlphaNotice: false);
    }
    return AppConfigModel.fromJson(Map<String, dynamic>.from(data));
  }
}

final appConfigServiceProvider = Provider<AppConfigService>((ref) {
  return AppConfigService(ref.watch(dioClientProvider));
});
