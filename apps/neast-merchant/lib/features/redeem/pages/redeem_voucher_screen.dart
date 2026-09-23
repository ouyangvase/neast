import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/common/widgets/neast_subpage_header_section.dart';
import 'package:neast/features/common/widgets/success_result_dialog.dart';
import 'package:neast/features/redeem/models/redeem_voucher_route_args.dart';
import 'package:neast/features/redeem/services/redeem_service.dart';
import 'package:neast/features/redeem/widgets/redeem_bottom_actions.dart';
import 'package:neast/features/redeem/widgets/redeem_detail_card.dart';
import 'package:neast/features/redeem/widgets/redeem_valid_banner.dart';
import 'package:neast/features/redeem/widgets/redeem_voucher_card.dart';

/// 兑换优惠券（确认兑换）页面。
class RedeemVoucherScreen extends ConsumerWidget {
  const RedeemVoucherScreen({super.key, this.routeArgs});

  final RedeemVoucherRouteArgs? routeArgs;

  Future<void> _onConfirm(BuildContext context, WidgetRef ref) async {
    final args = routeArgs;
    if (args == null || args.code.isEmpty) return;

    await EasyLoading.show();
    try {
      final result = await ref.runGuarded(
        () => ref.read(redeemServiceProvider).redeemByCode(args.code),
      );
      if (!context.mounted || result == null) return;

      await SuccessResultDialog.show(
        imageAsset: 'assets/images/redeem/success.png',
        message: 'Redemption successful',
        onClose: () {
          if (context.mounted) context.pop();
        },
      );
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = routeArgs;
    final preview = args?.preview;

    if (preview == null) {
      return Scaffold(
        backgroundColor: GivePointsColors.background,
        body: Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Voucher not found'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: GivePointsColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NeastSubpageHeaderOverlapLayout(
                    subtitle: 'Verify carefully before confirming',
                    title: 'Confirm Redeem',
                    overlapChild: RedeemVoucherCard(preview: preview),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RedeemDetailCard(preview: preview),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: RedeemValidBanner(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          RedeemBottomActions(
            onConfirm: () => _onConfirm(context, ref),
          ),
        ],
      ),
    );
  }
}
