import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/common/widgets/neast_subpage_header_section.dart';
import 'package:neast/features/common/widgets/upload_progress_dialog.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/give_points/models/receipt_capture_result.dart';
import 'package:neast/features/give_points/models/receipt_confirm_payload.dart';
import 'package:neast/features/give_points/providers/points_setting_provider.dart';
import 'package:neast/features/give_points/services/receipt_capture_service.dart';
import 'package:neast/features/give_points/widgets/receipt_details_form_section.dart';
import 'package:neast/features/give_points/widgets/receipt_points_preview_card.dart';
import 'package:neast/features/give_points/widgets/receipt_preview_overlap_card.dart';

/// Receipt Details — Step 1 of 2。
class ReceiptDetailsScreen extends ConsumerStatefulWidget {
  const ReceiptDetailsScreen({
    super.key,
    required this.capture,
  });

  final ReceiptCaptureResult capture;

  @override
  ConsumerState<ReceiptDetailsScreen> createState() =>
      _ReceiptDetailsScreenState();
}

class _ReceiptDetailsScreenState extends ConsumerState<ReceiptDetailsScreen> {
  late ReceiptCaptureResult _capture;

  late final TextEditingController _receiptNumberController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _capture = widget.capture;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantInfoProvider.notifier).fetchIfNeeded();
      _refreshPointsSetting();
    });

    _receiptNumberController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _amountController.addListener(_onAmountChanged);
  }

  Future<bool> _refreshPointsSetting() async {
    await EasyLoading.show();
    try {
      return await ref.read(pointsSettingProvider.notifier).fetch(silent: true);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  void _onAmountChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _receiptNumberController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _retake() async {
    try {
      final local = await ReceiptCaptureService.scanDocument();
      if (!mounted) return;
      if (local == null) return;

      final imagePath = local.imagePath;
      if (imagePath == null || imagePath.isEmpty) {
        ToastUtil.showError('Failed to read receipt image.');
        return;
      }

      final uploaded = await uploadFileWithProgressDialog(
        context: context,
        ref: ref,
        file: File(imagePath),
        filename: local.fileName,
      );
      if (!mounted) return;
      if (uploaded == null) return;

      setState(
        () => _capture = local.withUploaded(
          imageUrl: uploaded.url,
          uploadPath: uploaded.path,
          fileName: uploaded.name.isNotEmpty ? uploaded.name : local.fileName,
        ),
      );
    } on ReceiptCaptureException catch (e) {
      if (!mounted) return;
      ToastUtil.showError(e.message);
    }
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _onContinue() async {
    _dismissKeyboard();
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ToastUtil.showError('Please enter receipt amount.');
      return;
    }
    final amount = double.tryParse(amountText.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      ToastUtil.showError('Please enter a valid receipt amount.');
      return;
    }

    var pointsSetting = ref.read(pointsSettingProvider).value;
    if (pointsSetting == null) {
      final loaded = await _refreshPointsSetting();
      if (!mounted) return;
      if (!loaded) {
        ToastUtil.showError('Failed to load points settings.');
        return;
      }
      pointsSetting = ref.read(pointsSettingProvider).value;
      if (pointsSetting == null) {
        ToastUtil.showError('Failed to load points settings.');
        return;
      }
    }

    final outlet = ref.read(merchantInfoProvider).value?.name.trim() ?? '';
    final merchantId = ref.read(merchantInfoProvider).value?.id ?? 0;
    if (merchantId <= 0) {
      ToastUtil.showError('Failed to load merchant info.');
      return;
    }

    final confirmed = await context.push<bool>(
      AppRoutes.confirmPoints,
      extra: ReceiptConfirmPayload(
        capture: _capture,
        outlet: outlet,
        merchantId: merchantId,
        receiptNumber: _receiptNumberController.text.trim(),
        amountText: amountText,
        yuanToPoints: pointsSetting.yuanToPoints,
        notes: _notesController.text.trim(),
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final outletName = ref.watch(merchantInfoProvider).value?.name.trim() ?? '';
    final yuanToPoints =
        ref.watch(pointsSettingProvider).value?.yuanToPoints ?? 0;

    return Scaffold(
      backgroundColor: GivePointsColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NeastSubpageHeaderOverlapLayout(
            subtitle: 'Step 1 of 2',
            title: 'Receipt Details',
            fillColor: GivePointsColors.background,
            overlapChild: ReceiptPreviewOverlapCard(
              capture: _capture,
              onRetake: _retake,
            ),
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
                    ReceiptDetailsFormSection(
                      outletName: outletName,
                      receiptNumberController: _receiptNumberController,
                      amountController: _amountController,
                      notesController: _notesController,
                    ),
                    const SizedBox(height: 20),
                    ReceiptPointsPreviewSection(
                      amountText: _amountController.text,
                      yuanToPoints: yuanToPoints,
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
                onTap: _onContinue,
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
                        'Continue',
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
