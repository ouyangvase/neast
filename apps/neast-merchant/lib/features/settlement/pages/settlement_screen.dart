import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/settlement/providers/settlement_overview_provider.dart';
import 'package:neast/features/settlement/settlement_colors.dart';
import 'package:neast/features/settlement/widgets/settlement_header.dart';
import 'package:neast/features/settlement/widgets/settlement_how_charges_card.dart';
import 'package:neast/features/settlement/widgets/settlement_stats_card.dart';

class SettlementScreen extends ConsumerWidget {
  const SettlementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final overviewAsync = ref.watch(settlementOverviewProvider);
    final overview = overviewAsync.value;
    final showPayNow = overview?.showPayNow ?? false;

    if (overviewAsync.isLoading && overview == null) {
      return const ColoredBox(
        color: SettlementColors.background,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
      );
    }

    return ColoredBox(
      color: SettlementColors.background,
      child: RefreshIndicator(
        onRefresh: () =>
            ref.read(settlementOverviewProvider.notifier).fetch(silent: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SettlementHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SettlementStatsCard(),
                    if (showPayNow) ...[
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.settlementPayment),
                        behavior: HitTestBehavior.opaque,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: brandBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Pay Now',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'FD',
                                  fontVariations: [
                                    FontVariation('wght', 500),
                                  ],
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'How Neast Charges You',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'FD',
                        fontVariations: [FontVariation('wght', 500)],
                        color: brandBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SettlementHowChargesCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
