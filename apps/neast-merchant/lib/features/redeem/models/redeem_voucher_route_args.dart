import 'package:neast/features/redeem/models/redeem_voucher_preview_model.dart';

/// 进入核销确认页的路由参数（校验结果 + 原始码）。
class RedeemVoucherRouteArgs {
  const RedeemVoucherRouteArgs({
    required this.preview,
    required this.code,
  });

  final RedeemVoucherPreviewModel preview;
  final String code;
}
