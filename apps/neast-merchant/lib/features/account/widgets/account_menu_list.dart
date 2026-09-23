import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/account_assets.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/account/widgets/delete_account_dialog.dart';
import 'package:neast/features/auth/services/auth_service.dart';

/// Account 页面菜单区：Business / Finance / Operations 三个分组。
class AccountMenuList extends ConsumerWidget {
  const AccountMenuList({super.key});

  static final NumberFormat _amountFormat = NumberFormat('#,##0.00', 'en_US');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchant = ref.watch(merchantInfoProvider).value;
    final balance = double.tryParse(merchant?.balance ?? '') ?? 0;
    final balanceText = 'RM ${_amountFormat.format(balance)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AccountMenuSection(
          title: 'Business',
          groups: [
            [
              _MenuItemData(
                title: 'Store Profile',
                icon: AccountAssets.menuStoreProfile,
                onTap: () => context.push(AppRoutes.storeProfile),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        _AccountMenuSection(
          title: 'Finance',
          groups: [
            [
              _MenuItemData(
                title: 'Wallet Top Up',
                icon: AccountAssets.menuWalletTopUp,
                trailing: balanceText,
                onTap: () => context.push(AppRoutes.wallet),
              ),
              _MenuItemData(
                title: 'Invoice & Billing',
                icon: AccountAssets.menuInvoiceBilling,
                onTap: () => context.push(AppRoutes.invoice),
              ),
              _MenuItemData(
                title: 'Transaction History',
                icon: AccountAssets.menuTransactionHistory,
                onTap: () => context.push(AppRoutes.transactionHistory),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        _AccountMenuSection(
          title: 'Operations',
          groups: [
            [
              _MenuItemData(
                title: 'Legal',
                icon: AccountAssets.menuLegal,
                onTap: () => context.push(AppRoutes.richText, extra: 'Legal'),
              ),
            ],
            [
              _MenuItemData(
                title: 'Delete Account',
                icon: AccountAssets.menuDeleteAccount,
                onTap: () => DeleteAccountDialog.show(),
              ),
              _MenuItemData(
                title: 'Log Out',
                icon: AccountAssets.menuLogOut,
                onTap: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MenuItemData {
  const _MenuItemData({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String icon;
  final String? trailing;
  final VoidCallback? onTap;
}

class _AccountMenuSection extends StatelessWidget {
  const _AccountMenuSection({
    required this.title,
    required this.groups,
  });

  final String title;
  final List<List<_MenuItemData>> groups;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'FD',
            fontVariations: [FontVariation('wght', 500)],
            color: brandBlue,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < groups.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _MenuCard(items: groups[i]),
        ],
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});

  final List<_MenuItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBF4FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            _AccountMenuItem(
              data: items[i],
              showDivider: i != items.length - 1,
            ),
        ],
      ),
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.data,
    this.showDivider = true,
  });

  final _MenuItemData data;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      children: [
        InkWell(
          onTap: data.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.5, vertical: 16),
            child: Row(
              children: [
                SvgPicture.asset(data.icon, width: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: brandBlue,
                    ),
                  ),
                ),
                if (data.trailing != null) ...[
                  Text(
                    data.trailing!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: brandBlue.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
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
            color: Color(0xFFBFD6F0),
          ),
      ],
    );
  }
}
