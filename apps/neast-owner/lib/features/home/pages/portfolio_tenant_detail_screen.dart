import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/utils/notifier_utils.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/landlord_rent_detail_model.dart';
import 'package:neast_landlords/features/home/providers/home_dashboard_provider.dart';
import 'package:neast_landlords/features/home/providers/landlord_rent_detail_provider.dart';
import 'package:neast_landlords/features/home/providers/portfolio_detail_provider.dart';
import 'package:neast_landlords/features/home/services/landlord_rent_service.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/rent_terminate_confirm_dialog.dart';
import 'package:neast_landlords/features/properties/utils/property_file_actions.dart';

/// Portfolio 租客租约详情页。
class PortfolioTenantDetailScreen extends ConsumerWidget {
  const PortfolioTenantDetailScreen({
    super.key,
    required this.rentId,
  });

  final int rentId;

  static const _headerAspectRatio = 375 / 133;
  static const _cardOverlap = 24.0;
  static const _dangerColor = Color(0xFFFF4444);

  Future<void> _handleTerminate(
    BuildContext context,
    WidgetRef ref,
    LandlordRentDetailModel detail,
  ) async {
    await RentTerminateConfirmDialog.show(
      onConfirm: () async {
        final ok = await ref.runGuarded(() async {
          await ref.read(landlordRentServiceProvider).terminateRent(detail.id);
          return true;
        });
        if (ok != true || !context.mounted) return;

        ref.invalidate(portfolioDetailProvider);
        ref.invalidate(homeDashboardProvider);
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(landlordRentDetailProvider(rentId));
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: HomeColors.background,
        body: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _ErrorBody(rentId: rentId),
          data: (detail) {
            if (detail == null) {
              return _ErrorBody(rentId: rentId);
            }

            return Column(
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
                            child: _DetailCard(
                              detail: detail,
                              onAgreementTap: detail.fileUrl.isEmpty
                                  ? null
                                  : () => openRemoteFileUrl(
                                        context,
                                        detail.fileUrl,
                                      ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24 - _cardOverlap),
                      ],
                    ),
                  ),
                ),
                if (detail.canTerminate)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      bottomPadding + 16,
                    ),
                    child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            _handleTerminate(context, ref, detail),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _dangerColor,
                          side: const BorderSide(color: _dangerColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Terminate Rent',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'HG',
                            fontVariations: [FontVariation('wght', 500)],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ErrorBody extends ConsumerWidget {
  const _ErrorBody({required this.rentId});

  final int rentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Failed to load rent detail',
            style: TextStyle(fontSize: 14, color: HomeColors.label),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                ref.invalidate(landlordRentDetailProvider(rentId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.detail,
    this.onAgreementTap,
  });

  final LandlordRentDetailModel detail;
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
            detail.propertyName.isNotEmpty
                ? detail.propertyName
                : 'Property',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 600)],
              color: brandBlue,
            ),
          ),
          if (detail.propertyAddress.isNotEmpty) ...[
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
                    detail.propertyAddress,
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
          ],
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
                HomeAvatar(
                  initials: detail.tenantInitials,
                  imageUrl: detail.tenantAvatar,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.tenantName.isNotEmpty
                            ? detail.tenantName
                            : 'Tenant',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 500)],
                          color: brandBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'RM ${detail.displayAmount}',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'FD',
                          fontVariations: [FontVariation('wght', 500)],
                          color: brandBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onAgreementTap != null)
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
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Pay day', value: detail.displayPayDay),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'First pay month',
            value: detail.displayFirstPayMonth,
          ),
          const SizedBox(height: 8),
          _InfoRow(label: 'Lease term', value: detail.displayLeaseTerm),
          const SizedBox(height: 8),
          _InfoRow(label: 'Lease period', value: detail.displayLeasePeriod),
          const SizedBox(height: 8),
          _InfoRow(label: 'Expire date', value: detail.displayExpireDate),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 108,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: HomeColors.label,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 500)],
              color: brandBlue,
            ),
          ),
        ),
      ],
    );
  }
}
