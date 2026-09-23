import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/providers/coupon_list_provider.dart';
import 'package:neast/features/coupon/providers/my_voucher_list_provider.dart';
import 'package:neast/features/coupon/utils/coupon_redeem_actions.dart';
import 'package:neast/features/coupon/widgets/coupon_action_button.dart';
import 'package:neast/features/coupon/widgets/coupon_detail_body.dart';
import 'package:neast/features/coupon/widgets/coupon_detail_hero.dart';

/// 优惠券详情页。
class CouponDetailScreen extends ConsumerStatefulWidget {
  const CouponDetailScreen({
    super.key,
    required this.item,
    this.listCategoryId,
    this.fromMyVouchers = false,
  });

  final CouponListItemModel item;

  /// 进入详情时列表页选中的分类（null = All）。
  final int? listCategoryId;

  /// 是否从「My Vouchers」页进入。
  final bool fromMyVouchers;

  @override
  ConsumerState<CouponDetailScreen> createState() => _CouponDetailScreenState();
}

class _CouponDetailScreenState extends ConsumerState<CouponDetailScreen> {
  static const _contentTopRadius = 22.0;

  late CouponListItemModel _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Future<void> _onRedeem() async {
    final updated = await redeemCoupon(ref, _item);
    if (updated == null || !mounted) return;
    setState(() => _item = updated);
    if (widget.fromMyVouchers) {
      ref.invalidate(myVoucherListProvider);
      ref.invalidate(myVoucherCountProvider);
    } else {
      await ref
          .read(couponListProvider(widget.listCategoryId).notifier)
          .refresh();
    }
  }

  void _onUseNow() {
    showCouponQrcode(_item);
  }

  void _onActionTap() {
    switch (_item.actionStatus) {
      case CouponActionStatus.redeem:
        _onRedeem();
      case CouponActionStatus.useNow:
        _onUseNow();
      case CouponActionStatus.fullyRedeemed:
        break;
    }
  }

  void _onShareTap() {
    ToastUtil.show('Share is not available yet');
  }

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: brandBlueLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Reward Detail',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 400)],
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: _onShareTap,
                child: Image.asset(
                  'assets/icon/share.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ColoredBox(
                      color: brandBlueLight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: _contentTopRadius + 10,
                        ),
                        child: CouponDetailHero(imageUrl: _item.image),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -_contentTopRadius),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(_contentTopRadius),
                          ),
                        ),
                        child: CouponDetailBody(item: _item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: CouponActionButton(
                  status: _item.actionStatus,
                  requiredPoints: _item.requiredPoints,
                  layout: CouponActionButtonLayout.detail,
                  onPressed:
                      _item.actionStatus == CouponActionStatus.fullyRedeemed
                      ? null
                      : _onActionTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
