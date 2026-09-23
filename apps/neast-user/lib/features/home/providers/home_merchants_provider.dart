import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/core/services/location_service.dart';
import 'package:neast/features/merchant/models/merchant_list_kind.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/services/merchant_service.dart';

abstract class HomeLocationMerchantsNotifier
    extends PaginatedListNotifier<MerchantModel> {
  bool locationUnavailable = false;
  String? locationErrorMessage;

  double? _latitude;
  double? _longitude;

  @override
  int get initialPageSize => 10;

  @override
  Future<void> initialLoad() async {
    if (state.list.isNotEmpty) return;

    try {
      final coords = await ref.read(currentLocationProvider.future);
      _latitude = coords.latitude;
      _longitude = coords.longitude;
      locationUnavailable = false;
      locationErrorMessage = null;
    } on LocationUnavailableException catch (e) {
      locationUnavailable = true;
      locationErrorMessage = e.message;
      return;
    }

    await super.initialLoad();
  }

  @override
  Future<List<MerchantModel>> fetchPage(int page, int pageSize) async {
    if (_latitude == null || _longitude == null) {
      return [];
    }

    final response = await fetchMerchantPage(
      latitude: _latitude!,
      longitude: _longitude!,
      page: page,
      limit: pageSize,
    );

    return response.items;
  }

  Future<MerchantListResponse> fetchMerchantPage({
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
  });

  @override
  void onFetchError(Object error, StackTrace stack) {
    // 首页区块内展示，不弹 Toast
  }
}

class HomeAllMerchantsNotifier extends HomeLocationMerchantsNotifier {
  @override
  Future<MerchantListResponse> fetchMerchantPage({
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
  }) {
    return ref.read(merchantServiceProvider).fetchList(
          latitude: latitude,
          longitude: longitude,
          page: page,
          limit: limit,
        );
  }
}

class HomeRecommendedMerchantsNotifier extends HomeLocationMerchantsNotifier {
  @override
  Future<MerchantListResponse> fetchMerchantPage({
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
  }) {
    return ref.read(merchantServiceProvider).fetchRecommendedList(
          latitude: latitude,
          longitude: longitude,
          page: page,
          limit: limit,
        );
  }
}

class HomeNearbyListMerchantsNotifier extends HomeLocationMerchantsNotifier {
  @override
  Future<MerchantListResponse> fetchMerchantPage({
    required double latitude,
    required double longitude,
    required int page,
    required int limit,
  }) {
    return ref.read(merchantServiceProvider).fetchNearbyList(
          latitude: latitude,
          longitude: longitude,
          page: page,
          limit: limit,
        );
  }
}

final homeAllMerchantsProvider =
    NotifierProvider<HomeAllMerchantsNotifier, PaginatedListState<MerchantModel>>(
  HomeAllMerchantsNotifier.new,
);

final homeRecommendedMerchantsProvider = NotifierProvider<
    HomeRecommendedMerchantsNotifier, PaginatedListState<MerchantModel>>(
  HomeRecommendedMerchantsNotifier.new,
);

final homeNearbyListMerchantsProvider = NotifierProvider<
    HomeNearbyListMerchantsNotifier, PaginatedListState<MerchantModel>>(
  HomeNearbyListMerchantsNotifier.new,
);

HomeLocationMerchantsNotifier homeMerchantsNotifier(
  WidgetRef ref,
  MerchantListKind kind,
) {
  return switch (kind) {
    MerchantListKind.all => ref.read(homeAllMerchantsProvider.notifier),
    MerchantListKind.recommended =>
      ref.read(homeRecommendedMerchantsProvider.notifier),
    MerchantListKind.nearby =>
      ref.read(homeNearbyListMerchantsProvider.notifier),
  };
}

PaginatedListState<MerchantModel> homeMerchantsState(
  WidgetRef ref,
  MerchantListKind kind,
) {
  return switch (kind) {
    MerchantListKind.all => ref.watch(homeAllMerchantsProvider),
    MerchantListKind.recommended => ref.watch(homeRecommendedMerchantsProvider),
    MerchantListKind.nearby => ref.watch(homeNearbyListMerchantsProvider),
  };
}
