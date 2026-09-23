import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/portfolio_snapshot_models.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

/// 资产概览 Rent Roll 卡片。
class PortfolioRentRollCard extends StatelessWidget {
  const PortfolioRentRollCard({
    super.key,
    required this.rentRoll,
  });

  final String rentRoll;

  /// CSS: linear-gradient(138deg, #FFF8EC 0%, #ECB87D 100%)
  static const _gradient = LinearGradient(
    colors: [
      Color(0xFFFFF8EC),
      Color(0xFFECB87D),
    ],
    transform: GradientRotation(138 * math.pi / 180),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: _gradient,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rent Roll',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: Color(0xFF9A6B2E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'RM$rentRoll',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 600)],
                    color: Color(0xFFE3A86D),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
          Image.asset(
            HomeAssets.coin,
            width: 56,
            height: 56,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

/// 资产概览租客卡片。
class PortfolioTenantCard extends StatelessWidget {
  const PortfolioTenantCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final PortfolioTenantItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: HomeCard(
        child: Row(
          children: [
            HomeAvatar(
              initials: item.initials,
              imageUrl: item.avatar,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 500)],
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.address,
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 400)],
                      color: HomeColors.label,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              HomeAssets.agreementCircle,
              width: 22,
              height: 22,
            ),
          ],
        ),
      ),
    );
  }
}
