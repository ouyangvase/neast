import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/providers/coupon_list_provider.dart';
import 'package:neast/features/coupon/providers/my_voucher_list_provider.dart';
import 'package:neast/features/coupon/widgets/coupon_qrcode_dialog.dart';
import 'package:neast/features/coupon/widgets/coupon_redeem_confirm_dialog.dart';

/// 展示优惠券核销二维码。
void showCouponQrcode(CouponListItemModel item) {
  if (item.qrcode.isEmpty && item.sn.isEmpty) {
    ToastUtil.show('QR code is not available');
    return;
  }

  CouponQrcodeDialog.show(
    qrcode: item.qrcode,
    voucherName: item.name,
    sn: item.sn,
  );
}

/// 确认并兑换优惠券，成功返回更新后的 item。
Future<CouponListItemModel?> redeemCoupon(
  WidgetRef ref,
  CouponListItemModel item,
) async {
  final confirmed = await CouponRedeemConfirmDialog.show(item);
  if (!confirmed) return null;

  await EasyLoading.show();
  try {
    final updated = await ref.runGuarded(
      () => ref.read(couponRedeemProvider).redeem(item.id),
    );
    if (updated == null) return null;
    ToastUtil.show('Redeemed successfully');
    ref.invalidate(myVoucherCountProvider);
    return updated;
  } finally {
    await EasyLoading.dismiss();
  }
}
