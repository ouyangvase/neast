import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';

/// Account 页面商家信息卡片，展示头像、名称、商户 ID 与认证状态。
class AccountProfileCard extends ConsumerWidget {
  const AccountProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final merchant = ref.watch(merchantInfoProvider).value;

    final name = merchant?.name.trim().isNotEmpty == true ? merchant!.name : '-';
    final isVerified = merchant?.status == 1;
    final imageUrl = merchant?.image.trim() ?? '';
    final avatarInitials = merchant?.avatarInitials ?? '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFE7F2FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _Avatar(
            imageUrl: imageUrl,
            initials: avatarInitials,
            brandBlue: brandBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'ID:${merchant?.id ?? '-'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: brandBlue.withValues(alpha: 0.45),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 8),
                      const _VerifiedBadge(),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.imageUrl,
    required this.initials,
    required this.brandBlue,
  });

  final String imageUrl;
  final String initials;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    const double size = 48;

    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: brandBlue,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );

    return ClipOval(
      child: imageUrl.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (context, url) => fallback,
              errorWidget: (context, url, error) => fallback,
            )
          : fallback,
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF3EBF7A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'VERIFIED',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
