import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/refer/providers/refer_dashboard_provider.dart';
import 'package:neast/features/refer/utils/refer_share_actions.dart';
import 'package:neast/features/refer/widgets/refer_code_card.dart';
import 'package:neast/features/refer/widgets/refer_header.dart';
import 'package:neast/features/refer/widgets/refer_how_it_works_card.dart';
import 'package:neast/features/refer/widgets/refer_milestones_card.dart';
import 'package:neast/features/refer/widgets/refer_promo_banner.dart';
// import 'package:neast/features/refer/widgets/refer_referrals_section.dart';

/// 推荐页主页面。
class ReferScreen extends ConsumerStatefulWidget {
  const ReferScreen({super.key});

  @override
  ConsumerState<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends ConsumerState<ReferScreen> {
  /// 折叠后标题/返回按钮的深色，与品牌深蓝一致。
  static const _collapsedForeground = Color(0xFF0D2567);

  final ScrollController _scrollController = ScrollController();

  /// 顶栏折叠进度：0 完全展开（顶图蓝色），1 完全折叠（白色）。
  double _collapseProgress = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(referDashboardProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final distance =
        (ReferHeader.expandedHeight(context) - kToolbarHeight).clamp(
      1.0,
      double.infinity,
    );
    final progress = (_scrollController.offset / distance).clamp(0.0, 1.0);
    if (progress != _collapseProgress) {
      setState(() => _collapseProgress = progress);
    }
  }

  Future<void> _copyInvitationCode() async {
    final dashboard = ref.read(referDashboardProvider).asData?.value;
    final code = dashboard?.invitationCode.trim() ?? '';
    if (code.isEmpty) {
      ToastUtil.show('Invitation code is not available');
      return;
    }

    await Clipboard.setData(ClipboardData(text: code));
    ToastUtil.show('Copied to clipboard');
  }

  Future<void> _copyInviteUrl() async {
    final dashboard = ref.read(referDashboardProvider).asData?.value;
    final url = dashboard?.inviteUrl.trim() ?? '';
    if (url.isEmpty) {
      ToastUtil.show('Invite link is not available');
      return;
    }

    await Clipboard.setData(ClipboardData(text: url));
    ToastUtil.show('Copied to clipboard');
  }

  Future<void> _shareViaWhatsapp() async {
    final dashboard = ref.read(referDashboardProvider).asData?.value;
    await shareInviteViaWhatsapp(dashboard?.inviteUrl ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(referDashboardProvider);
    final dashboard = dashboardAsync.asData?.value;

    // 在 [0.2, 0.7] 区间内由白渐变到深色，确保切换发生在背景由蓝转白的过程中。
    final colorT =
        ((_collapseProgress - 0.2) / (0.7 - 0.2)).clamp(0.0, 1.0);
    final foreground =
        Color.lerp(Colors.white, _collapsedForeground, colorT)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _collapseProgress > 0.45
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9F6),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: ReferHeader.expandedHeight(context),
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: ReferHeader.contentBackground,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: foreground,
                ),
              ),
              centerTitle: true,
              title: Text(
                'Refer Friends & Earn',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
              flexibleSpace: ReferHeader.flexibleSpace(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 23)),
            const SliverToBoxAdapter(child: ReferPromoBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: ReferCodeCard(
                invitationCode: dashboard?.invitationCode ?? '',
                inviteeRewardPoints: dashboard?.inviteeRewardText ?? '-',
                onCopy: dashboard == null ? null : _copyInvitationCode,
                onInvite: dashboard == null ? null : _copyInviteUrl,
                onWhatsappShare: dashboard == null ? null : _shareViaWhatsapp,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            const SliverToBoxAdapter(child: ReferHowItWorksCard()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            const SliverToBoxAdapter(child: ReferMilestonesCard()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // const SliverToBoxAdapter(child: ReferReferralsSection()),
            // const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
