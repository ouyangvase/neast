import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/reward/pages/reward_tier_screen.dart';

final List<GoRoute> rewardRoutes = [
  GoRoute(
    path: AppRoutes.rewardTier,
    name: 'rewardTier',
    builder: (context, state) => const RewardTierScreen(),
  ),
];
