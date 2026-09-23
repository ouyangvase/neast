import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/account/account_assets.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';
import 'package:neast_landlords/features/account/widgets/delete_account_dialog.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';

/// Account 页面 Operations 菜单区。
class AccountOperationsSection extends ConsumerWidget {
  const AccountOperationsSection({super.key});

  void _openRichText(BuildContext context, String title) {
    context.push(AppRoutes.richText, extra: title);
  }

  Future<void> _handleDeleteAccount(WidgetRef ref) async {
    await EasyLoading.show();
    try {
      await ref.read(landlordInfoProvider.notifier).deleteAccount();
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Operations',
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontFamily: 'HG',
        //     fontVariations: [FontVariation('wght', 500)],
        //     color: brandBlue,
        //   ),
        // ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _AccountMenuItem(
                title: 'Bank detail',
                leading: Icon(
                  Icons.account_balance_outlined,
                  size: 22,
                  color: brandBlue,
                ),
                onTap: () => context.push(AppRoutes.bankDetail),
              ),
              _AccountMenuItem(
                title: 'About Us',
                icon: AccountAssets.menuAboutUs,
                onTap: () => _openRichText(context, 'About Us'),
              ),
              _AccountMenuItem(
                title: 'Terms and Conditions',
                icon: AccountAssets.menuTerms,
                onTap: () => _openRichText(context, 'Terms and Conditions'),
              ),
              _AccountMenuItem(
                title: 'Privacy Policy',
                icon: AccountAssets.menuPrivacy,
                onTap: () => _openRichText(context, 'Privacy Policy'),
              ),
              _AccountMenuItem(
                title: 'Delete Account',
                icon: AccountAssets.menuDeleteAccount,
                onTap: () => DeleteAccountDialog.show(
                  onConfirm: () => _handleDeleteAccount(ref),
                ),
              ),
              _AccountMenuItem(
                title: 'Log Out',
                icon: AccountAssets.menuLogOut,
                showDivider: false,
                onTap: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.title,
    this.icon,
    this.leading,
    this.showDivider = true,
    this.onTap,
  }) : assert(icon != null || leading != null);

  final String title;
  final String? icon;
  final Widget? leading;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                leading ??
                    Image.asset(
                      icon!,
                      width: 22,
                      height: 22,
                    ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: brandBlue,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: brandBlue.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: brandBlue.withValues(alpha: 0.12),
          ),
      ],
    );
  }
}
