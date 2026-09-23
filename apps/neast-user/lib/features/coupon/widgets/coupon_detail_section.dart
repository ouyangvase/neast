import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 优惠券详情页信息分区。
class CouponDetailSection extends StatelessWidget {
  const CouponDetailSection({
    super.key,
    required this.title,
    this.body,
    this.bulletItems = const [],
  });

  final String title;
  final String? body;
  final List<String> bulletItems;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        if (body != null)
          Text(
            body!,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: brandBlue.withValues(alpha: 0.55),
            ),
          ),
        if (bulletItems.isNotEmpty)
          ...bulletItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: brandBlue.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: brandBlue.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
