import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/rich_text/models/agreement_model.dart';
import 'package:neast_landlords/features/rich_text/services/agreement_service.dart';

class AgreementContentNotifier extends AsyncNotifier<AgreementModel?> {
  AgreementContentNotifier(this.title);

  final String title;

  @override
  Future<AgreementModel?> build() async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return ref.read(agreementServiceProvider).fetchByTitle(trimmed);
  }

  /// 进入页面时静默刷新：有缓存时不展示全屏 loading。
  Future<void> silentRefresh() async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      state = const AsyncData(null);
      return;
    }

    final previous = state.hasValue ? state.value : null;
    final hasCache = state.hasValue && !state.isLoading;

    if (!hasCache) {
      state = const AsyncLoading();
    }

    try {
      final result =
          await ref.read(agreementServiceProvider).fetchByTitle(trimmed);
      state = AsyncData(result);
    } catch (error, stackTrace) {
      if (hasCache) {
        state = AsyncData(previous);
        return;
      }
      state = AsyncError(error, stackTrace);
    }
  }
}

final agreementContentProvider = AsyncNotifierProvider.family<
    AgreementContentNotifier, AgreementModel?, String>(
  AgreementContentNotifier.new,
);
