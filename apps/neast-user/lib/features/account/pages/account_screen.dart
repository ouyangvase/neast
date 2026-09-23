import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/account/widgets/account_guest_login_card.dart';
import 'package:neast/features/account/widgets/account_header.dart';
import 'package:neast/features/account/widgets/account_menu_card.dart';
import 'package:neast/features/wallet/providers/wallet_balance_provider.dart';

/// Account 主页面。
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(isLoggedInProvider)) return;
      ref.read(userProfileProvider.notifier).fetchIfNeeded();
      ref.read(walletBalanceProvider.notifier).silentRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: brandBlueLight,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 20),
                        child: isLoggedIn
                            ? const AccountHeader()
                            : const AccountGuestLoginCard(),
                      ),
                      const AccountMenuCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
