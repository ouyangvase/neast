import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/home/providers/home_dashboard_provider.dart';
import 'package:neast/features/main/pages/main_screen.dart';
import 'package:neast/features/pay_rent/utils/rent_file_actions.dart';

/// 首页「Next Rent」卡片。
class NextRentCard extends ConsumerWidget {
  const NextRentCard({super.key});

  static const _bg = Color(0xFFF3E4C4);
  static const _titleColor = Color(0xFF5A3209);
  static const _brandBlue = Color(0xFF0851AA);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rent = ref.watch(homeDashboardProvider).value?.nextRent;

    final amountText = rent != null ? formatRentAmount(rent.amount) : 'RM --';
    final subtitle = rent != null && rent.landlordName.isNotEmpty
        ? rent.landlordName
        : 'Your rent';
    final dueText = rent != null && rent.displayDueText.isNotEmpty
        ? rent.displayDueText
        : 'No upcoming rent';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Rent',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 500)],
                        color: _titleColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 500)],
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amountText,
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 800)],
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dueText,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 400)],
                        color: _titleColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/home/pay-rent.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () =>
                  ref.read(selectedIndexProvider.notifier).state = MainTab.payRent,
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Pay Rent Now',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
