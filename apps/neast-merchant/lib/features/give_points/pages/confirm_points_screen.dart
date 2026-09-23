import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/common/widgets/neast_subpage_header_section.dart';
import 'package:neast/features/common/widgets/success_result_dialog.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/give_points/models/receipt_confirm_payload.dart';
import 'package:neast/features/give_points/providers/give_points_today_commission_provider.dart';
import 'package:neast/features/give_points/providers/give_points_today_stats_provider.dart';
import 'package:neast/features/give_points/services/give_points_service.dart';
import 'package:neast/features/give_points/widgets/confirm_points_customer_card.dart';
import 'package:neast/features/give_points/widgets/confirm_points_summary_card.dart';

/// Confirm Points — Step 2 of 2。
class ConfirmPointsScreen extends ConsumerStatefulWidget {
  const ConfirmPointsScreen({
    super.key,
    required this.payload,
  });

  final ReceiptConfirmPayload payload;

  @override
  ConsumerState<ConfirmPointsScreen> createState() =>
      _ConfirmPointsScreenState();
}

class _ConfirmPointsScreenState extends ConsumerState<ConfirmPointsScreen> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _onConfirm() async {
    _dismissKeyboard();
    await EasyLoading.show();
    try {
      final success = await ref.runGuarded(
        () => ref.read(givePointsServiceProvider).confirmGivePoints(
              customer: _phoneController.text.trim(),
              amount: widget.payload.amountText,
              points: widget.payload.autoPoints,
              merchantId: widget.payload.merchantId,
              receiptNumber: widget.payload.receiptNumber,
              receiptPath: widget.payload.capture.uploadPath,
              notes: widget.payload.notes,
            ),
      );
      if (!mounted || success != true) return;

      await ref
          .read(givePointsTodayCommissionProvider.notifier)
          .fetch(silent: true);
      await ref.read(givePointsTodayStatsProvider.notifier).fetch(silent: true);

      if (!mounted) return;

      SuccessResultDialog.show(
        imageAsset: 'assets/images/give_points/success.png',
        message: 'Successfully gifted points',
        onClose: () {
          if (mounted) context.pop(true);
        },
      );
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: GivePointsColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastSubpageHeaderOverlapLayout(
            subtitle: 'Step 2 of 2',
            title: 'Confirm Points',
            fillColor: GivePointsColors.background,
            overlapChild: ConfirmPointsSummaryCard(payload: widget.payload),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _dismissKeyboard,
              behavior: HitTestBehavior.translucent,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConfirmPointsCustomerCard(
                      phoneController: _phoneController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: GestureDetector(
                onTap: _onConfirm,
                behavior: HitTestBehavior.opaque,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: brandBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Center(
                      child: Text(
                        'Confirm Give Points',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'FD',
                          fontVariations: [FontVariation('wght', 500)],
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// extra 缺失时的兜底页。
class ConfirmPointsMissingScreen extends StatelessWidget {
  const ConfirmPointsMissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Points')),
      body: const Center(child: Text('Receipt data not found.')),
    );
  }
}
