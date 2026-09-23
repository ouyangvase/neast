import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/notification/providers/notification_unread_provider.dart';
import 'package:neast/features/home/widgets/journey_streak_card.dart';
import 'package:neast/features/home/widgets/my_voucher_card.dart';
import 'package:neast/features/home/widgets/nearby_deals_section.dart';
import 'package:neast/features/home/widgets/next_rent_card.dart';
import 'package:neast/features/home/widgets/promo_carousel.dart';
import 'package:neast/features/home/widgets/todays_reward_card.dart';

/// 首页主页面（改版）。
///
/// 顶部为深蓝背景图 [home_bg]，其上依次为按钮行（logo + 消息 + 二维码）、
/// 两行问候语、Next Rent / Today's Reward 两张卡片；下方为顶部圆角 22 的白色
/// 内容区（Nearby Deals / Your Journey / My Voucher / For Rent）。
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _contentBg = Color(0xFFF6F9F6);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(isLoggedInProvider)) return;
      ref.read(userProfileProvider.notifier).fetchIfNeeded();
      ref.read(notificationUnreadProvider.notifier).refresh();
    });
  }

  void _onLoginRequiredTap() {
    context.push(AppRoutes.login);
  }

  Future<void> _onQrTap() async {
    var profile = ref.read(userProfileProvider).value;
    if (profile == null) {
      await ref.read(userProfileProvider.notifier).fetchIfNeeded();
      profile = ref.read(userProfileProvider).value;
    }

    if (!mounted || profile == null || profile.qrCode.isEmpty) return;

    context.push(AppRoutes.myQr);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final greetingName =
        ref.watch(userProfileProvider).value?.greetingName ?? '-';
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: _contentBg,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/home/home_bg.png',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topPadding + 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildTopBar(),
                  ),
                  if (isLoggedIn) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: _buildGreeting(greetingName),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
                      child: NextRentCard(),
                    ),
                  ] else
                    const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: TodaysRewardCard(),
                  ),
                  _buildWhiteContent(isLoggedIn),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/home/hone_logo.png',
          height: 28,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        _buildNotificationButton(),
        const SizedBox(width: 12),
        _buildQrButton(),
      ],
    );
  }

  Widget _buildGreeting(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello,',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildWhiteContent(bool isLoggedIn) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: _contentBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const NearbyDealsSection(),
          if (isLoggedIn) ...[
            const SizedBox(height: 2),
            const JourneyStreakCard(),
            const SizedBox(height: 16),
            const MyVoucherCard(),
          ],
          const PromoCarousel(),
        ],
      ),
    );
  }

  Widget _buildQrButton() {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return GestureDetector(
      onTap: isLoggedIn ? _onQrTap : _onLoginRequiredTap,
      behavior: HitTestBehavior.opaque,
      child: Image.asset(
        'assets/images/home/qrcode.png',
        width: 36,
        height: 36,
      ),
    );
  }

  Widget _buildNotificationButton() {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final hasUnread = ref.watch(notificationUnreadProvider).value ?? false;

    return GestureDetector(
      onTap: isLoggedIn
          ? () => context.push(AppRoutes.notification)
          : _onLoginRequiredTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/home/msg-icon.png',
            width: 36,
            height: 36,
          ),
          if (hasUnread)
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
    );
  }
}
