import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';

enum GuestLoginPlaceholderStyle {
  /// 整块内容区占位（Pay Rent / Account）
  full,

  /// 卡片占位（Home / Reward 个人区块）
  card,
}

/// 游客态登录引导占位。
class GuestLoginPlaceholder extends StatelessWidget {
  const GuestLoginPlaceholder({
    super.key,
    this.style = GuestLoginPlaceholderStyle.full,
    this.message = 'Log in to access your account features',
    this.iconAsset,
  });

  final GuestLoginPlaceholderStyle style;
  final String message;
  final String? iconAsset;

  void _onLoginTap(BuildContext context) {
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    if (style == GuestLoginPlaceholderStyle.card) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: brandBlue.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _LoginButton(
              brandBlue: brandBlue,
              onTap: () => _onLoginTap(context),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(brandBlue),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: brandBlue.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            _LoginButton(
              brandBlue: brandBlue,
              onTap: () => _onLoginTap(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color brandBlue) {
    if (iconAsset != null) {
      return Image.asset(
        iconAsset!,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      Icons.lock_outline_rounded,
      size: 48,
      color: brandBlue.withValues(alpha: 0.35),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.brandBlue,
    required this.onTap,
  });

  final Color brandBlue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: brandBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Log in / Sign up',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
