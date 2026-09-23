import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/app_config/models/app_config_model.dart';
import 'package:neast/features/app_config/services/app_config_service.dart';

class AppConfigNotifier extends AsyncNotifier<AppConfigModel> {
  @override
  Future<AppConfigModel> build() async {
    try {
      return await ref.read(appConfigServiceProvider).fetch();
    } catch (_) {
      return const AppConfigModel(showAlphaNotice: false);
    }
  }
}

final appConfigProvider =
    AsyncNotifierProvider<AppConfigNotifier, AppConfigModel>(
  AppConfigNotifier.new,
);
