import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';

/// Account 页游客态登录引导卡片（替换 [AccountHeader]）。
class AccountGuestLoginCard extends StatelessWidget {
  const AccountGuestLoginCard({super.key});

  void _onLoginTap(BuildContext context) {
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: brandBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: brandBlue.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Neast',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'HG',
                    fontVariations: const [FontVariation('wght', 600)],
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Log in to access your account',
                  style: TextStyle(
                    fontSize: 13,
                    color: brandBlue.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _onLoginTap(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: brandBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
