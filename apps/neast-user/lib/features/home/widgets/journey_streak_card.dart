import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/home/models/home_dashboard_model.dart';
import 'package:neast/features/home/providers/home_dashboard_provider.dart';

/// 首页「Your Journey」连续缴租里程碑卡片。
class JourneyStreakCard extends ConsumerWidget {
  const JourneyStreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journey = ref.watch(homeDashboardProvider).maybeWhen(
          data: (dashboard) => dashboard.journey,
          orElse: () => const HomeJourneyModel(),
        );

    final streakLabel = journey.streakLabel.isNotEmpty
        ? journey.streakLabel
        : '— Month Streak';
    final streakStatus = journey.streakStatus.isNotEmpty
        ? journey.streakStatus
        : "Keep it up! You're doing great.";

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(AppRoutes.tentScore),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment(-0.45, -0.89),
            end: Alignment(0.45, 0.89),
            colors: [
              Color(0xFF234FA5),
              Color(0xFF022468),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 18,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Journey',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'HG',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    streakLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 600)],
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    streakStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'HG',
                      fontVariations: const [FontVariation('wght', 500)],
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/home/func1-icon2.png',
              width: 56,
              height: 56,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
