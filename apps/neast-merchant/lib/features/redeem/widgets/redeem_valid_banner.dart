import 'package:flutter/material.dart';
import 'package:neast/features/give_points/give_points_colors.dart';

/// 券有效性提示横幅。
class RedeemValidBanner extends StatelessWidget {
  const RedeemValidBanner({super.key});

  static const _green = Color(0xFF2BB673);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _green.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'VALID',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Voucher is valid at this outlet. ',
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: _green,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Once confirmed, it cannot be reused. Action will be '
                        'logged under your staff ID.',
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      color: GivePointsColors.label,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
