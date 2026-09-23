import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_list_provider.dart';
import 'package:neast/features/pay_rent/providers/rent_detail_history_provider.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_card_shadow.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_property_journey_card.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_tenancy_sections.dart';
import 'package:neast/features/pay_rent/widgets/rent_terminate_confirm_dialog.dart';

/// 租金详情页：房产信息 + 租金金额 + Property Journey。
class PayRentDetailScreen extends ConsumerWidget {
  const PayRentDetailScreen({
    super.key,
    required this.rent,
  });

  final RentModel rent;

  static const _blueExtension = 40.0;
  static const _contentTopRadius = 22.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlueLight = context.appColors.brandBlueLight;
    final historyAsync = ref.watch(rentDetailHistoryProvider(rent.id));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brandBlueLight,
        appBar: AppBar(
          backgroundColor: brandBlueLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Rent Detail',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'HG',
              color: Colors.white,
              fontVariations: [FontVariation('wght', 500)],
            ),
          ),
        ),
        body: Column(
          children: [
            ColoredBox(
              color: brandBlueLight,
              child: const SizedBox(height: _blueExtension),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(_contentTopRadius),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -_blueExtension,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _InfoCard(rent: rent),
                          const SizedBox(height: 12),
                          _AmountCard(rent: rent),
                          const SizedBox(height: 12),
                          historyAsync.when(
                            data: (items) =>
                                PayRentPropertyJourneyCard(items: items),
                            loading: () => const _JourneyLoadingCard(),
                            error: (_, __) =>
                                const PayRentPropertyJourneyCard(items: []),
                          ),
                          if (rent.canTerminate) ...[
                            const SizedBox(height: 24),
                            _TerminateRentSection(rent: rent),
                          ],
                        ],
                      ),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rent});

  final RentModel rent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: PayRentCardShadow.boxShadow,
      ),
      child: PayRentTenancyInfoSection(
        rent: rent,
        showChevron: false,
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({required this.rent});

  final RentModel rent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: PayRentCardShadow.boxShadow,
      ),
      child: PayRentAmountSection(rent: rent),
    );
  }
}

class _JourneyLoadingCard extends StatelessWidget {
  const _JourneyLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: PayRentCardShadow.boxShadow,
      ),
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _TerminateRentSection extends ConsumerWidget {
  const _TerminateRentSection({required this.rent});

  final RentModel rent;

  static const _dangerColor = Color(0xFFFF4444);

  Future<void> _handleTerminate(BuildContext context, WidgetRef ref) async {
    await RentTerminateConfirmDialog.show(
      onConfirm: () async {
        final ok = await ref.runGuarded(() async {
          await ref.read(rentServiceProvider).terminateRent(rent.id);
          return true;
        });
        if (ok != true || !context.mounted) return;

        ref.invalidate(payRentListProvider);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: () => _handleTerminate(context, ref),
        style: OutlinedButton.styleFrom(
          foregroundColor: _dangerColor,
          side: const BorderSide(color: _dangerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Terminate Rent',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
