import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/ack_item_model.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

/// 待确认收款卡片。
class AckCard extends StatelessWidget {
  const AckCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final AckItemModel item;
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
            HomeAvatar(initials: item.initials),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 500)],
                      color: brandBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.paidText,
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
            Icon(Icons.chevron_right, size: 20, color: brandBlue),
          ],
        ),
      ),
    );
  }
}
