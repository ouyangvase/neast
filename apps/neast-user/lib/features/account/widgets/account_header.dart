import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/reward/providers/reward_dashboard_provider.dart';

/// Account 页面用户区：白色圆形头像 + 姓名、联系方式与会员徽章。
///
/// 背景由父级提供（品牌浅蓝），此处文字为白色。
class AccountHeader extends ConsumerWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final profile = ref.watch(userProfileProvider).value;
    final tierName = ref.watch(rewardDashboardProvider).maybeWhen(
          data: (dashboard) => dashboard.tier.current.displayName,
          orElse: () => '-',
        );

    final name = profile?.fullName ?? '-';
    final account = profile?.account ?? '';
    final avatarLetter = profile?.avatarLetter ?? '?';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            avatarLetter,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: brandBlue,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (account.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  account,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC56E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tierName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
