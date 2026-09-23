import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
import 'package:neast/core/deep_link/deep_link_navigation.dart';
import 'package:neast/core/theme/app_colors.dart';
//import 'package:neast/features/app_config/providers/app_config_provider.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/account/pages/account_screen.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/home/pages/home_screen.dart';
import 'package:neast/features/main/main_tab_assets.dart';
import 'package:neast/features/main/widgets/beta_tag.dart';
// import 'package:neast/features/main/widgets/alpha_notice_banner.dart';
// import 'package:neast/features/main/widgets/alpha_notice_dialog.dart';
import 'package:neast/features/pay_rent/pages/pay_rent_screen.dart';
import 'package:neast/features/push/services/push_notification_service.dart';
import 'package:neast/features/reward/pages/reward_screen.dart';

final selectedIndexProvider = StateProvider<MainTab>((ref) => MainTab.home);

enum MainTab {
  home,
  payRent,
  reward,
  account,
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      flushPendingDeepLinkOnMain(context, ref);
      _initializePushNotificationIfLoggedIn();
      // _showAlphaNoticeDialogIfNeeded();
    });
  }

  // void _showAlphaNoticeDialogIfNeeded() {
  //   final showAlpha =
  //       ref.read(appConfigProvider).value?.showAlphaNotice ?? false;
  //   if (!showAlpha || !mounted) {
  //     return;
  //   }

  //   final fromSplash =
  //       GoRouterState.of(context).uri.queryParameters['fromSplash'] == 'true';
  //   if (!fromSplash) {
  //     return;
  //   }

  //   AlphaNoticeDialog.show();
  // }

  Future<void> _initializePushNotificationIfLoggedIn() async {
    if (!ref.read(isLoggedInProvider)) {
      return;
    }

    await ref.read(pushNotificationServiceProvider).initialize();
  }

  late final List<Widget> _pages = const [
    HomeScreen(),
    PayRentScreen(),
    RewardScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(selectedIndexProvider);
    // final showAlpha =
    //     ref.watch(appConfigProvider).value?.showAlphaNotice ?? false;
    final brandBlue = context.appColors.brandBlue;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          ToastUtil.showWarning('再按一次返回键退出应用');
          return false;
        }
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9F6),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (showAlpha) const AlphaNoticeBanner(),
            Expanded(
              child: Stack(
                children: [
                  IndexedStack(
                    index: selectedTab.index,
                    children: _pages,
                  ),
                  if (kShowBetaTag)
                    Positioned(
                      top: MediaQuery.paddingOf(context).top + 1,
                      left: 0,
                      right: 0,
                      child: const Center(child: BetaTag()),
                    ),
                ],
              ),
            ),
          ],
        ),
        drawerEnableOpenDragGesture: selectedTab == MainTab.home ||
            selectedTab == MainTab.account,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, -4),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedTab.index,
              backgroundColor: Colors.white,
              selectedItemColor: brandBlue,
              unselectedItemColor: const Color(0xFFB0B0B0),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: _tabIcon(MainTabAssets.home),
                  activeIcon: _tabIcon(MainTabAssets.homeAct),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _tabIcon(MainTabAssets.payRent),
                  activeIcon: _tabIcon(MainTabAssets.payRentAct),
                  label: 'Pay rent',
                ),
                BottomNavigationBarItem(
                  icon: _tabIcon(MainTabAssets.reward),
                  activeIcon: _tabIcon(MainTabAssets.rewardAct),
                  label: 'Reward',
                ),
                BottomNavigationBarItem(
                  icon: _tabIcon(MainTabAssets.account),
                  activeIcon: _tabIcon(MainTabAssets.accountAct),
                  label: 'Account',
                ),
              ],
              onTap: (index) {
                ref.read(selectedIndexProvider.notifier).state =
                    MainTab.values[index];
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabIcon(String asset) {
    return SvgPicture.asset(
      asset,
      width: 26,
      height: 26,
    );
  }
}
