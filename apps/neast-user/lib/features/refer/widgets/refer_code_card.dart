import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 推荐页推荐码卡片。
class ReferCodeCard extends StatelessWidget {
  const ReferCodeCard({
    super.key,
    required this.invitationCode,
    required this.inviteeRewardPoints,
    this.onCopy,
    this.onInvite,
    this.onWhatsappShare,
  });

  final String invitationCode;
  final String inviteeRewardPoints;
  final VoidCallback? onCopy;
  final VoidCallback? onInvite;
  final VoidCallback? onWhatsappShare;

  static const _whatsappGreen = Color(0xFF63B701);
  static const _footerFontSize = 11.0;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final displayCode = invitationCode.isEmpty ? '-' : invitationCode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your Referral Code',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: brandBlue.withValues(alpha: 0.15),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Opacity(
                      opacity: 0,
                      child: _CopyAction(brandBlue: brandBlue),
                    ),
                  ),
                ),
                Text(
                  displayCode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: brandBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _CopyAction(
                      brandBlue: brandBlue,
                      onTap: onCopy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '2,847 users earned from referrals this month',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: brandBlue.withValues(alpha: 0.75),
            ),
          ),
          Text(
            'Join them – your next invite could be the one!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: brandBlue.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onInvite,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: brandBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Invite & Earn Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onWhatsappShare,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _whatsappGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Share via Whatsapp',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: _footerFontSize,
                color: brandBlue.withValues(alpha: 0.45),
              ),
              children: [
                const TextSpan(text: 'Your friends also gets '),
                TextSpan(
                  text: inviteeRewardPoints,
                  style: TextStyle(
                    fontSize: _footerFontSize,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                ),
                const TextSpan(text: ' when they pay rent'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyAction extends StatelessWidget {
  const _CopyAction({
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.copy_outlined,
            size: 16,
            color: brandBlue.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            'COPY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: brandBlue.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
