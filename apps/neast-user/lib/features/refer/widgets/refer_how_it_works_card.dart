import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 推荐页 How It Works 卡片。
class ReferHowItWorksCard extends StatelessWidget {
  const ReferHowItWorksCard({super.key});

  static const _headerBlue = Color(0xFF0D2567);

  static const _steps = [
    (
      step: 'Step 1',
      title: 'Share Your Code',
      icon: Icons.send_outlined,
    ),
    (
      step: 'Step 2',
      title: 'Friend Signs Up & Pays Rent',
      icon: Icons.people_outline,
    ),
    (
      step: 'Step 3',
      title: 'Both Earn Rewards',
      icon: Icons.emoji_events_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      decoration: BoxDecoration(
        color: _headerBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'How It Works',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _steps.map((step) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        step.step,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                step.icon,
                                size: 24,
                                color: const Color(0xFFD4A017),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                step.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 1.3,
                                  fontWeight: FontWeight.w400,
                                  color: brandBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
