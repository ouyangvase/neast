import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/features/home/models/portfolio_snapshot_models.dart';
import 'package:neast_landlords/features/home/services/portfolio_service.dart';

class PortfolioDetailNotifier extends AsyncNotifier<PortfolioDetailModel?> {
  @override
  Future<PortfolioDetailModel?> build() async {
    if (!ref.watch(authProvider)) {
      return null;
    }
    return ref.read(portfolioServiceProvider).fetchDetail();
  }

  Future<void> refresh() async {
    if (!ref.read(authProvider)) {
      return;
    }
    state = await AsyncValue.guard(
      () => ref.read(portfolioServiceProvider).fetchDetail(),
    );
  }
}

final portfolioDetailProvider =
    AsyncNotifierProvider<PortfolioDetailNotifier, PortfolioDetailModel?>(
  PortfolioDetailNotifier.new,
);
