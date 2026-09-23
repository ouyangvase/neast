import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/services/coupon_service.dart';

class MerchantCouponListNotifier
    extends Notifier<AsyncValue<List<CouponListItemModel>>> {
  MerchantCouponListNotifier(this.merchantId);

  final int merchantId;
  bool _hasLoaded = false;

  @override
  AsyncValue<List<CouponListItemModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> open() async {
    await load(silent: _hasLoaded);
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      state = const AsyncValue.loading();
    }

    state = await AsyncValue.guard(
      () => ref.read(couponServiceProvider).fetchListByMerchant(merchantId),
    );
    if (state.hasValue) {
      _hasLoaded = true;
    }
  }
}

final merchantCouponListProvider = NotifierProvider.family<
    MerchantCouponListNotifier,
    AsyncValue<List<CouponListItemModel>>,
    int>(MerchantCouponListNotifier.new);
