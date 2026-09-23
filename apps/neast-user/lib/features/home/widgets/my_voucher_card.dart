import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';

/// 首页「My Voucher」入口卡片。
///
/// 点击「Check It Out」跳转到我的优惠券页面。
class MyVoucherCard extends StatelessWidget {
  const MyVoucherCard({super.key});

  static const _bg = Color(0xFFFBE6BE);
  static const _titleColor = Color(0xFF895A1B);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 9, 12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Voucher',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 600)],
                    color: _titleColor,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.myVouchers),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFCBAC7B),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'Check It Out',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 600)],
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/home/my-voucher-icon.png',
            width: 112,
            height: 64,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
