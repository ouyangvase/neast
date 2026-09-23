import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// How to Earn 步骤卡片（积分兑换 / 商家二维码等页面共用）。
class HowToEarnCard extends StatelessWidget {
  const HowToEarnCard({
    super.key,
    required this.steps,
  });

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (index) {
              final isLast = index == steps.length - 1;
              return _StepRow(
                text: steps[index],
                isLast: isLast,
                brandBlue: brandBlue,
              );
            }),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              'n',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: brandBlue.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.text,
    required this.isLast,
    required this.brandBlue,
  });

  final String text;
  final bool isLast;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: brandBlue, width: 1.5),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: brandBlue.withValues(alpha: 0.25),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: brandBlue.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
