import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/services/location_service.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/merchant/models/merchant_category_model.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/services/merchant_service.dart';

/// 商家地图页状态。
class MerchantMapState {
  const MerchantMapState({
    this.isLoading = false,
    this.locationUnavailable = false,
    this.locationErrorMessage,
    this.latitude,
    this.longitude,
    this.selectedCategoryId,
    this.merchants = const [],
  });

  final bool isLoading;
  final bool locationUnavailable;
  final String? locationErrorMessage;
  final double? latitude;
  final double? longitude;
  final int? selectedCategoryId;
  final List<MerchantModel> merchants;

  MerchantMapState copyWith({
    bool? isLoading,
    bool? locationUnavailable,
    String? locationErrorMessage,
    double? latitude,
    double? longitude,
    int? selectedCategoryId,
    bool clearSelectedCategory = false,
    List<MerchantModel>? merchants,
  }) {
    return MerchantMapState(
      isLoading: isLoading ?? this.isLoading,
      locationUnavailable: locationUnavailable ?? this.locationUnavailable,
      locationErrorMessage: locationErrorMessage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      merchants: merchants ?? this.merchants,
    );
  }
}

class MerchantMapNotifier extends Notifier<MerchantMapState> {
  @override
  MerchantMapState build() => const MerchantMapState();

  Future<void> initialize() async {
    if (state.latitude != null && state.merchants.isNotEmpty) return;
    await _loadMerchants();
  }

  Future<void> selectCategory(int? categoryId) async {
    if (state.selectedCategoryId == categoryId) return;

    state = state.copyWith(
      selectedCategoryId: categoryId,
      clearSelectedCategory: categoryId == null,
      isLoading: true,
    );
    await _loadMerchants(keepLocation: true);
  }

  Future<void> _loadMerchants({bool keepLocation = false}) async {
    state = state.copyWith(isLoading: true);

    double? latitude = keepLocation ? state.latitude : null;
    double? longitude = keepLocation ? state.longitude : null;

    if (latitude == null || longitude == null) {
      try {
        final coords = await ref.read(currentLocationProvider.future);
        latitude = coords.latitude;
        longitude = coords.longitude;
      } on LocationUnavailableException catch (e) {
        state = state.copyWith(
          isLoading: false,
          locationUnavailable: true,
          locationErrorMessage: e.message,
        );
        return;
      }
    }

    final merchants = await ref.runGuarded(
      () => ref.read(merchantServiceProvider).fetchNearby(
            latitude: latitude!,
            longitude: longitude!,
            categoryId: state.selectedCategoryId,
          ),
    );

    if (merchants == null) {
      state = state.copyWith(
        isLoading: false,
        latitude: latitude,
        longitude: longitude,
        locationUnavailable: false,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      locationUnavailable: false,
      locationErrorMessage: null,
      latitude: latitude,
      longitude: longitude,
      merchants: merchants,
    );
  }
}

final merchantMapProvider =
    NotifierProvider<MerchantMapNotifier, MerchantMapState>(
  MerchantMapNotifier.new,
);

/// 商家分类列表（不含 All）。
final merchantCategoriesProvider =
    FutureProvider<List<MerchantCategoryModel>>((ref) async {
  return ref.read(merchantServiceProvider).fetchCategories();
});

/// 地图页分类 chips：首个固定 All，其后为接口分类。
final merchantMapCategoryChipsProvider =
    Provider<AsyncValue<List<MerchantCategoryChip>>>((ref) {
  final categoriesAsync = ref.watch(merchantCategoriesProvider);

  return categoriesAsync.whenData((categories) {
    return [
      const MerchantCategoryChip.all(),
      ...categories.map(MerchantCategoryChip.category),
      const MerchantCategoryChip.pointsDeal(),
    ];
  });
});

class MerchantCategoryChip {
  const MerchantCategoryChip.all()
      : label = 'All',
        categoryId = null;

  const MerchantCategoryChip.pointsDeal()
      : label = '5X Points',
        categoryId = 5;

  MerchantCategoryChip.category(MerchantCategoryModel category)
      : label = category.name,
        categoryId = category.id;

  final String label;
  final int? categoryId;

  bool get isAll => categoryId == null;

  bool get isPointsDeal => categoryId == 5;
}
