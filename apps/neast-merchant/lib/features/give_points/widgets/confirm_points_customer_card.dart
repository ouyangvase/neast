import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/give_points/give_points_colors.dart';
import 'package:neast/features/give_points/services/give_points_service.dart';
import 'package:neast/features/give_points/widgets/give_points_white_card.dart';
import 'package:neast/features/scan/utils/qr_scanner_launcher.dart';

/// Confirm Points — 识别客户卡片。
class ConfirmPointsCustomerCard extends ConsumerStatefulWidget {
  const ConfirmPointsCustomerCard({
    super.key,
    required this.phoneController,
  });

  final TextEditingController phoneController;

  @override
  ConsumerState<ConfirmPointsCustomerCard> createState() =>
      _ConfirmPointsCustomerCardState();
}

class _ConfirmPointsCustomerCardState
    extends ConsumerState<ConfirmPointsCustomerCard> {
  static const _inputFill = Color(0xFFF2F9FC);

  static const _phoneGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF234FA5), Color(0xFF4A82EF)],
  );

  int? _parseUserIdFromQr(String raw) {
    try {
      final decoded = jsonDecode(raw.trim());
      if (decoded is! Map) {
        return null;
      }

      final userId = decoded['user_id'];
      if (userId is int && userId > 0) {
        return userId;
      }
      if (userId is String) {
        final parsed = int.tryParse(userId.trim());
        if (parsed != null && parsed > 0) {
          return parsed;
        }
      }
    } on FormatException {
      return null;
    }

    return null;
  }

  Future<void> _openQrScanner() async {
    final result = await openQrScanner(context);
    if (!mounted || result == null || result.isEmpty) {
      return;
    }

    final userId = _parseUserIdFromQr(result);
    if (userId == null) {
      ToastUtil.showError('Invalid customer QR code');
      return;
    }

    await EasyLoading.show();
    try {
      final account = await ref.runGuarded(
        () => ref
            .read(givePointsServiceProvider)
            .fetchCustomerAccountByUserId(userId),
      );
      if (!mounted || account == null || account.isEmpty) {
        return;
      }

      widget.phoneController.text = account;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GivePointsWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Identify Customer',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 12),
          _ModeButtons(
            onQrTap: _openQrScanner,
            brandBlue: brandBlue,
            inputFill: _inputFill,
            phoneGradient: _phoneGradient,
          ),
          const SizedBox(height: 12),
          _PhoneInput(
            controller: widget.phoneController,
            brandBlue: brandBlue,
            fillColor: _inputFill,
          ),
        ],
      ),
    );
  }
}

class _ModeButtons extends StatelessWidget {
  const _ModeButtons({
    required this.onQrTap,
    required this.brandBlue,
    required this.inputFill,
    required this.phoneGradient,
  });

  final VoidCallback onQrTap;
  final Color brandBlue;
  final Color inputFill;
  final Gradient phoneGradient;

  static const _buttonPadding = EdgeInsets.symmetric(horizontal: 26, vertical: 9);
  static const _labelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: phoneGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: _buttonPadding,
            child: Text(
              'Phone',
              style: _labelStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onQrTap,
          behavior: HitTestBehavior.opaque,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: _buttonPadding,
              child: Text(
                'QR',
                style: _labelStyle.copyWith(color: brandBlue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput({
    required this.controller,
    required this.brandBlue,
    required this.fillColor,
  });

  final TextEditingController controller;
  final Color brandBlue;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: GivePointsColors.formLabel,
          height: 1.2,
        ),
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: 'Enter phone number, e.g. 60123456789',
          hintStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: GivePointsColors.formLabel,
            height: 1.2,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
