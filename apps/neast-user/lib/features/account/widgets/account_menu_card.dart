import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/account/widgets/delete_account_dialog.dart';
import 'package:neast/features/account/widgets/logout_confirm_dialog.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/wallet/providers/wallet_balance_provider.dart';
import 'package:neast/features/wallet/services/wallet_service.dart';

/// Account 页面菜单列表卡片。
class AccountMenuCard extends ConsumerWidget {
  const AccountMenuCard({super.key});

  Future<void> _handleDeleteAccount(WidgetRef ref) async {
    await EasyLoading.show();
    try {
      await ref.read(userProfileProvider.notifier).deleteAccount();
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _handleLogout(WidgetRef ref) async {
    await EasyLoading.show();
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      await ref.read(authProvider.notifier).logout();
    } finally {
      await EasyLoading.dismiss();
    }
  }

  void _goLogin(BuildContext context) {
    context.push(AppRoutes.login);
  }

  List<_MenuEntry> _buildItems(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final balanceAsync = ref.watch(walletBalanceProvider);
    final walletTrailing = balanceAsync.maybeWhen(
      data: (balance) => 'RM ${formatWalletBalanceDisplay(balance)}',
      orElse: () => 'RM 0',
    );

    final allItems = <_MenuEntry>[
      _MenuEntry(
        icon: 'assets/images/account/1.svg',
        title: 'Personal Information',
        guestAccessible: false,
        onTapLoggedIn: () => context.push(AppRoutes.personalData),
      ),
      _MenuEntry(
        icon: 'assets/images/account/2.svg',
        title: 'Notifications',
        guestAccessible: false,
        onTapLoggedIn: () => context.push(AppRoutes.notification),
      ),
      _MenuEntry(
        icon: 'assets/images/account/wallet.svg',
        title: 'Wallet',
        guestAccessible: false,
        trailing: isLoggedIn ? walletTrailing : null,
        onTapLoggedIn: () => context.push(AppRoutes.wallet),
      ),
      _MenuEntry(
        icon: 'assets/images/account/3.svg',
        title: 'Privacy & Security',
        guestAccessible: true,
        onTapLoggedIn: () =>
            context.push(AppRoutes.richText, extra: 'Privacy Policy'),
      ),
      _MenuEntry(
        icon: 'assets/images/account/4.svg',
        title: 'Terms & Conditions',
        guestAccessible: true,
        onTapLoggedIn: () =>
            context.push(AppRoutes.richText, extra: 'Terms and Conditions'),
      ),
      _MenuEntry(
        icon: 'assets/images/account/del.svg',
        title: 'Delete Account',
        guestAccessible: false,
        loggedInOnly: true,
        onTapLoggedIn: () => DeleteAccountDialog.show(
          onConfirm: () => _handleDeleteAccount(ref),
        ),
      ),
      _MenuEntry(
        icon: 'assets/images/account/5.svg',
        title: 'Log Out',
        guestAccessible: false,
        loggedInOnly: true,
        onTapLoggedIn: () => LogoutConfirmDialog.show(
          onConfirm: () => _handleLogout(ref),
        ),
      ),
    ];

    return allItems
        .where((item) => isLoggedIn || !item.loggedInOnly)
        .map(
          (item) => item.copyWith(
            onTap: () {
              if (isLoggedIn || item.guestAccessible) {
                item.onTapLoggedIn();
              } else {
                _goLogin(context);
              }
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _buildItems(context, ref);

    return Container(
      padding: const EdgeInsets.only(bottom: 170),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++)
            _AccountMenuItem(
              entry: items[i],
              showDivider: i != items.length - 1,
            ),
        ],
      ),
    );
  }
}

class _MenuEntry {
  const _MenuEntry({
    required this.icon,
    required this.title,
    required this.guestAccessible,
    required this.onTapLoggedIn,
    this.loggedInOnly = false,
    this.trailing,
    this.onTap,
  });

  final String icon;
  final String title;
  final bool guestAccessible;
  final bool loggedInOnly;
  final String? trailing;
  final VoidCallback onTapLoggedIn;
  final VoidCallback? onTap;

  _MenuEntry copyWith({VoidCallback? onTap}) {
    return _MenuEntry(
      icon: icon,
      title: title,
      guestAccessible: guestAccessible,
      loggedInOnly: loggedInOnly,
      trailing: trailing,
      onTapLoggedIn: onTapLoggedIn,
      onTap: onTap ?? this.onTap,
    );
  }
}

/// Account 页面菜单单项。
class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.entry,
    this.showDivider = true,
  });

  final _MenuEntry entry;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final blackText = context.appColors.blackText;

    return Column(
      children: [
        InkWell(
          onTap: entry.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                SvgPicture.asset(entry.icon, width: 24, height: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    entry.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 500)],
                      color: blackText,
                    ),
                  ),
                ),
                if (entry.trailing != null) ...[
                  Text(
                    entry.trailing!,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 500)],
                      color: blackText.withValues(alpha: 0.45),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                SvgPicture.asset(
                  'assets/images/account/right-arrow.svg',
                  width: 10,
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: blackText.withValues(alpha: 0.06),
          ),
      ],
    );
  }
}
