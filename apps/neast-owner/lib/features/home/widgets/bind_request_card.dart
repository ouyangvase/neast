import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/bind_request_item_model.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

/// 待绑定申请卡片。
class BindRequestCard extends StatelessWidget {
  const BindRequestCard({
    super.key,
    required this.item,
    this.onTap,
    this.onReject,
    this.onApprove,
    this.onAgreement,
  });

  final BindRequestItemModel item;
  final VoidCallback? onTap;
  final VoidCallback? onReject;
  final VoidCallback? onApprove;
  final VoidCallback? onAgreement;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: HomeCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              HomeAvatar(initials: item.initials),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 500)],
                        color: brandBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.propertyName,
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 400)],
                        color: HomeColors.label,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoLine(
            label: 'Rent',
            value: 'RM ${item.rent}',
            brandBlue: brandBlue,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _InfoLine(
                  label: 'Payday',
                  value: item.payday,
                  brandBlue: brandBlue,
                ),
              ),
              _AgreementButton(
                brandBlue: brandBlue,
                onTap: onAgreement,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Reject',
                  color: HomeColors.reject,
                  onTap: onReject,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Approve',
                  color: brandBlue,
                  onTap: onApprove,
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    required this.brandBlue,
  });

  final String label;
  final String value;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 400)],
            color: HomeColors.label,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'FD',
            fontVariations: [FontVariation('wght', 500)],
            color: brandBlue,
          ),
        ),
      ],
    );
  }
}

class _AgreementButton extends StatelessWidget {
  const _AgreementButton({
    required this.brandBlue,
    this.onTap,
  });

  final Color brandBlue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: brandBlue.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(HomeAssets.agreementIcon, width: 16, height: 16),
            const SizedBox(width: 6),
            Text(
              'Agreement',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: brandBlue,
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: brandBlue),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
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
        padding: const EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 500)],
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
