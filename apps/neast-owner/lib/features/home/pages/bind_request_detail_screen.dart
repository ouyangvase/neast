import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/utils/toast_util.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/bind_request_item_model.dart';
import 'package:neast_landlords/features/home/providers/bind_request_list_provider.dart';
import 'package:neast_landlords/features/home/providers/home_dashboard_provider.dart';
import 'package:neast_landlords/features/home/services/bind_request_service.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/bind_request_audit_confirm_dialog.dart';
import 'package:neast_landlords/features/properties/utils/property_file_actions.dart';

/// 待绑定申请详情页。
class BindRequestDetailScreen extends ConsumerStatefulWidget {
  const BindRequestDetailScreen({super.key, required this.item});

  final BindRequestItemModel item;

  @override
  ConsumerState<BindRequestDetailScreen> createState() =>
      _BindRequestDetailScreenState();
}

class _BindRequestDetailScreenState extends ConsumerState<BindRequestDetailScreen> {
  static const _headerAspectRatio = 375 / 133;
  static const _cardOverlap = 24.0;

  bool _submitting = false;

  Future<void> _confirmAudit(String result) async {
    if (_submitting || widget.item.id <= 0) return;

    final isReject = result == 'rejected';
    final confirmed = await BindRequestAuditConfirmDialog.show(
      isReject: isReject,
    );

    if (confirmed && mounted) {
      await _onAudit(result);
    }
  }

  Future<void> _onAudit(String result) async {
    if (_submitting || widget.item.id <= 0) return;

    setState(() => _submitting = true);
    await EasyLoading.show();
    try {
      await ref.read(bindRequestServiceProvider).audit(
            id: widget.item.id,
            result: result,
          );
      ref.invalidate(homeDashboardProvider);
      await ref.read(bindRequestListProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
    } catch (e) {
      ToastUtil.showError(e.toString());
    } finally {
      await EasyLoading.dismiss();
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final item = widget.item;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: HomeColors.background,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _headerAspectRatio,
                          child: Image.asset(
                            HomeAssets.houseEg,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SafeArea(
                            bottom: false,
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, -_cardOverlap),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _PropertyDetailCard(
                          item: item,
                          onAgreementTap: () =>
                              openRemoteFileUrl(context, item.fileUrl),
                        ),
                      ),
                    ),
                    SizedBox(height: 24 - _cardOverlap),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding + 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Reject',
                      color: HomeColors.reject,
                      onTap: _submitting ? null : () => _confirmAudit('rejected'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Approve',
                      color: brandBlue,
                      onTap: _submitting ? null : () => _confirmAudit('approved'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyDetailCard extends StatelessWidget {
  const _PropertyDetailCard({
    required this.item,
    this.onAgreementTap,
  });

  final BindRequestItemModel item;
  final VoidCallback? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            item.propertyName,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 600)],
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: HomeColors.label,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.propertyAddress,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: HomeColors.label,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Rental date: ${item.rentalDate}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: HomeColors.label,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: HomeColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAvatar(initials: item.initials),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.userName,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 500)],
                          color: brandBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.propertyName,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 400)],
                          color: HomeColors.label,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoLine(
                        label: 'Rent',
                        value: 'RM ${item.rent}',
                        brandBlue: brandBlue,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _InfoLine(
                              label: 'Payday',
                              value: item.payday,
                              brandBlue: brandBlue,
                            ),
                          ),
                          GestureDetector(
                            onTap: onAgreementTap,
                            behavior: HitTestBehavior.opaque,
                            child: Image.asset(
                              HomeAssets.agreementCircle,
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    required this.brandBlue,
  });

  final String label;
  final String value;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 400)],
            color: HomeColors.label,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'FD',
            fontVariations: [FontVariation('wght', 500)],
            color: brandBlue,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 500)],
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
