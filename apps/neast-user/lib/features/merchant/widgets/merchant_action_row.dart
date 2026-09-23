import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 商家详情页 Redeem / Map 操作按钮行。
class MerchantActionRow extends StatelessWidget {
  const MerchantActionRow({
    super.key,
    this.onRedeem,
    this.onMap,
  });

  final VoidCallback? onRedeem;
  final VoidCallback? onMap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onRedeem,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: brandBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Redeem',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onMap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: brandBlue.withValues(alpha: 0.25),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  'Map',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
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
