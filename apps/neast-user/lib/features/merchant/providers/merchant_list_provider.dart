import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_family_notifier.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';
import 'package:neast/core/services/location_service.dart';
import 'package:neast/features/merchant/models/merchant_list_kind.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/services/merchant_service.dart';

class MerchantListNotifier
    extends PaginatedListFamilyNotifier<MerchantModel, MerchantListKind> {
  MerchantListNotifier(super.arg);

  bool locationUnavailable = false;
  String? locationErrorMessage;

  double? _latitude;
  double? _longitude;

  @override
  int get initialPageSize => 15;

  Future<bool> ensureLocation() async {
    if (_latitude != null && _longitude != null) {
      locationUnavailable = false;
      return true;
    }

    try {
      final coords = await ref.read(currentLocationProvider.future);
      _latitude = coords.latitude;
      _longitude = coords.longitude;
      locationUnavailable = false;
      locationErrorMessage = null;
      return true;
    } on LocationUnavailableException catch (e) {
      locationUnavailable = true;
      locationErrorMessage = e.message;
      return false;
    }
  }

  @override
  Future<void> initialLoad() async {
    if (state.list.isNotEmpty) return;
    if (!await ensureLocation()) return;
    await super.initialLoad();
  }

  @override
  Future<List<MerchantModel>> fetchPage(int page, int pageSize) async {
    if (_latitude == null || _longitude == null) {
      return [];
    }

    final service = ref.read(merchantServiceProvider);
    final MerchantListResponse response;

    switch (arg) {
      case MerchantListKind.all:
        response = await service.fetchList(
          latitude: _latitude!,
          longitude: _longitude!,
          page: page,
          limit: pageSize,
        );
      case MerchantListKind.recommended:
        response = await service.fetchRecommendedList(
          latitude: _latitude!,
          longitude: _longitude!,
          page: page,
          limit: pageSize,
        );
      case MerchantListKind.nearby:
        response = await service.fetchNearbyList(
          latitude: _latitude!,
          longitude: _longitude!,
          page: page,
          limit: pageSize,
        );
    }

    return response.items;
  }
}

final merchantListProvider = NotifierProvider.family<
    MerchantListNotifier,
    PaginatedListState<MerchantModel>,
    MerchantListKind>(
  MerchantListNotifier.new,
);
