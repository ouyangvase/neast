import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/settlement/providers/settlement_overview_provider.dart';
import 'package:neast/features/settlement/settlement_assets.dart';

/// Settlement 页顶栏：背景图 + 应付金额信息。
class SettlementHeader extends ConsumerWidget {
  const SettlementHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(settlementOverviewProvider).value;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            SettlementAssets.header,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          'Settlement',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'FD',
                            fontVariations: [FontVariation('wght', 500)],
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          overview?.periodLabel ?? '-',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Amount Payable To Platform',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'RM ${overview?.formattedAmount ?? '-'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'FD',
                        fontVariations: [FontVariation('wght', 500)],
                        color: Colors.white,
                      ),
                    ),
                    if (overview?.dueDateLabel != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        overview!.dueDateLabel!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
