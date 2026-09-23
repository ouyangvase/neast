import 'package:flutter/material.dart';

/// 奖励等级 UI 常量（图标与样式；等级数据来自接口）。
abstract final class RewardTierConstants {
  static const goldIconAsset = 'assets/images/reward/gold-icon.png';
  static const diamondTierIcon = 'assets/images/reward/diamond-tier.png';
  static const platinumTierIcon = 'assets/images/reward/platinum-tier.png';
  static const goldTierIcon = 'assets/images/reward/gold-tier.png';
  static const silverTierIcon = 'assets/images/reward/sliver-tier.png';
  static const bronzeTierIcon = 'assets/images/reward/bronze-tier.png';

  static const currentTierCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFBF6DA),
      Color(0xFFFBDCAC),
    ],
  );

  static const tierRowBackground = Color(0xFFF4F5F9);
  static const activeRowBackground = Color(0xFFFDE6BC);

  static String iconAssetForTierId(int tierId) {
    return switch (tierId) {
      5 => diamondTierIcon,
      4 => platinumTierIcon,
      3 => goldTierIcon,
      2 => silverTierIcon,
      _ => bronzeTierIcon,
    };
  }
}
