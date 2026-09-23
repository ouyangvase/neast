import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/rent_item_model.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

/// 即将到期租金卡片。
class HomeDueSoonCard extends StatelessWidget {
  const HomeDueSoonCard({
    super.key,
    required this.item,
    this.onTap,
    this.onWhatsapp,
  });

  final RentItemModel item;
  final VoidCallback? onTap;
  final VoidCallback? onWhatsapp;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: HomeCard(
        child: Row(
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
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'RM ${item.amount}',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'FD',
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.statusText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: Color(0xFFE3A86D),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onWhatsapp,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HomeColors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SvgPicture.asset(
                  HomeAssets.whatsappIcon,
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
