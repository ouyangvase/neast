import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/rent_item_model.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

/// 逾期租金列表单项。
class HomeOverdueRentCard extends StatelessWidget {
  const HomeOverdueRentCard({
    super.key,
    required this.item,
    this.onView,
    this.onWhatsapp,
  });

  final RentItemModel item;
  final VoidCallback? onView;
  final VoidCallback? onWhatsapp;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return HomeCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAvatar(initials: item.initials),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 13,
                          color: HomeColors.label,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.statusText,
                          style: const TextStyle(
                            fontSize: 10,
                            color: HomeColors.label,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: HomeColors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'OVERDUE',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 400)],
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'RM ${item.amount}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'FD',
                      fontVariations: [FontVariation('wght', 500)],
                      color: HomeColors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ButtonGroup(onView: onView, onWhatsapp: onWhatsapp),
        ],
      ),
    );
  }
}

class _ButtonGroup extends StatelessWidget {
  const _ButtonGroup({
    this.onView,
    this.onWhatsapp,
  });

  final VoidCallback? onView;
  final VoidCallback? onWhatsapp;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onView,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: HomeColors.background,
                border: Border.all(color: brandBlue),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'View',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: brandBlue,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onWhatsapp,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: HomeColors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    HomeAssets.whatsappIcon,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Whatsapp',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 500)],
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
