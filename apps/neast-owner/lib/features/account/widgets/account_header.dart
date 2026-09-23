import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/account/account_assets.dart';
import 'package:neast_landlords/features/account/widgets/account_profile_card.dart';
import 'package:neast_landlords/features/home/providers/home_dashboard_provider.dart';

/// Account 页面头部：顶部背景图 + 房东信息卡 + 通知按钮。
class AccountHeader extends ConsumerWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final hasUnreadMessage =
        ref.watch(homeDashboardProvider).value?.hasUnreadMessage ?? false;
    final screenWidth = MediaQuery.of(context).size.width;
    final backgroundHeight = screenWidth * 150 / 375;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: backgroundHeight,
            child: Image.asset(
              AccountAssets.header,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: AccountProfileCard()),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () async {
                          await context.push(AppRoutes.notification);
                          await ref
                              .read(homeDashboardProvider.notifier)
                              .refresh();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: brandBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            if (hasUnreadMessage)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF4444),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
