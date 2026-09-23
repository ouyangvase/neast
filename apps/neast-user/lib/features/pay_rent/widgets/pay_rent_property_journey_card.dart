import 'package:flutter/material.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_card_shadow.dart';

/// Property Journey 卡片：按月展示还款状态网格。
class PayRentPropertyJourneyCard extends StatelessWidget {
  const PayRentPropertyJourneyCard({super.key, required this.items});

  final List<RentHistoryModel> items;

  static const _subtitleColor = Color(0xFF999999);
  static const _titleSuffixColor = Color(0xFF999999);

  static const _legendOnTimeColor = Color(0xFF039414);
  static const _legendLateColor = Color(0xFFE93F44);
  static const _legendUpcomingColor = Color(0xFFC7C7C7);

  static const _onTimeIcon = 'assets/images/pay_rent/ontime-icon.png';
  static const _lateIcon = 'assets/images/pay_rent/late-icon.png';
  static const _upcomingIcon = 'assets/images/pay_rent/upcoming-icon.png';

  static String _iconAsset(RentJourneyMonthStatus status) => switch (status) {
    RentJourneyMonthStatus.onTime => _onTimeIcon,
    RentJourneyMonthStatus.late => _lateIcon,
    RentJourneyMonthStatus.upcoming => _upcomingIcon,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: PayRentCardShadow.boxShadow,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 500)],
                color: Colors.black,
              ),
              children: [
                const TextSpan(text: 'Property Journey '),
                TextSpan(
                  text:
                      '(${items.length} ${items.length == 1 ? 'Month' : 'Months'})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontVariations: [FontVariation('wght', 400)],
                    color: _titleSuffixColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No payment history yet',
                  style: TextStyle(fontSize: 13, color: _subtitleColor),
                ),
              ),
            )
          else ...[
            Column(
              children: [
                for (var row = 0; row < items.length; row += 6) ...[
                  if (row > 0) const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = row; i < row + 6 && i < items.length; i++)
                        _MonthCell(item: items[i]),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LegendItem(
                  dotColor: PayRentPropertyJourneyCard._legendOnTimeColor,
                  label: 'On Time',
                ),
                _LegendItem(
                  dotColor: PayRentPropertyJourneyCard._legendLateColor,
                  label: 'Late',
                ),
                _LegendItem(
                  dotColor: PayRentPropertyJourneyCard._legendUpcomingColor,
                  label: 'Upcoming',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({required this.item});

  final RentHistoryModel item;

  @override
  Widget build(BuildContext context) {
    final status = item.journeyStatus;
    final iconAsset = PayRentPropertyJourneyCard._iconAsset(status);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconAsset, width: 26, height: 26, fit: BoxFit.contain),
        const SizedBox(height: 6),
        Text(
          item.journeyMonthLabel,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 500)],
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.dotColor,
    required this.label,
  });

  final Color dotColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 500)],
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
