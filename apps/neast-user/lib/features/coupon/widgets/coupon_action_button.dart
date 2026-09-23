import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';

enum CouponActionButtonLayout {
  list,
  detail,
}

/// 优惠券操作按钮（列表紧凑 / 详情全宽）。
class CouponActionButton extends StatelessWidget {
  const CouponActionButton({
    super.key,
    required this.status,
    this.requiredPoints = 0,
    this.onPressed,
    this.layout = CouponActionButtonLayout.list,
  });

  final CouponActionStatus status;
  final int requiredPoints;
  final VoidCallback? onPressed;
  final CouponActionButtonLayout layout;

  bool get _isEnabled => status != CouponActionStatus.fullyRedeemed;

  String get _detailLabel => switch (status) {
        CouponActionStatus.redeem =>
          'Redeem Now (${NumberFormat('#,###').format(requiredPoints)} pts)',
        CouponActionStatus.useNow => 'Use Now',
        CouponActionStatus.fullyRedeemed => 'Fully Redeemed',
      };

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final brandBlueLight = context.appColors.brandBlueLight;

    if (status == CouponActionStatus.fullyRedeemed) {
      if (layout == CouponActionButtonLayout.detail) {
        return _DisabledFullWidthButton(label: 'Fully Redeemed');
      }
      return SizedBox(
        width: 88,
        child: Text(
          'Fully Redeemed',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: brandBlue.withValues(alpha: 0.35),
          ),
        ),
      );
    }

    final label =
        layout == CouponActionButtonLayout.detail ? _detailLabel : _listLabel;
    final useOutlined = layout == CouponActionButtonLayout.list &&
        status == CouponActionStatus.useNow;

    if (layout == CouponActionButtonLayout.detail) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: brandBlueLight,
            foregroundColor: Colors.white,
            disabledBackgroundColor: brandBlueLight.withValues(alpha: 0.35),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (useOutlined) {
      return _CompactOutlinedButton(
        label: label,
        color: brandBlue,
        onTap: onPressed,
      );
    }

    return _CompactFilledButton(
      label: label,
      onTap: onPressed,
    );
  }

  String get _listLabel =>
      status == CouponActionStatus.redeem ? 'Redeem' : 'Use Now';
}

class _CompactFilledButton extends StatelessWidget {
  const _CompactFilledButton({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 88,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: brandBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _CompactOutlinedButton extends StatelessWidget {
  const _CompactOutlinedButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 88,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _DisabledFullWidthButton extends StatelessWidget {
  const _DisabledFullWidthButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}
