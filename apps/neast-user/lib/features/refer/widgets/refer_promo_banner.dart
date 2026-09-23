import 'package:flutter/material.dart';

/// 推荐页促销横幅。
class ReferPromoBanner extends StatelessWidget {
  const ReferPromoBanner({super.key});

  static const _referBanner = 'assets/images/refer/refer-banner.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          _referBanner,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
