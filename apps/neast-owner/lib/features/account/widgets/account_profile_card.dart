import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';

/// Account 页面房东信息卡片，展示头像、名称与邮箱。
class AccountProfileCard extends ConsumerWidget {
  const AccountProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final landlord = ref.watch(landlordInfoProvider).value;

    final name = landlord?.name.trim().isNotEmpty == true
        ? landlord!.name
        : '-';
    final email = landlord?.email.trim().isNotEmpty == true
        ? landlord!.email
        : '-';
    final avatarInitials = landlord?.avatarInitials ?? '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: brandBlue,
              shape: BoxShape.circle,
            ),
            child: Text(
              avatarInitials,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 11,
                    color: brandBlue.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
