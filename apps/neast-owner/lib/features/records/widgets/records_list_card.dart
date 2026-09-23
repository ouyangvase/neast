import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';
import 'package:neast_landlords/features/records/models/record_item_model.dart';

/// 收款记录列表卡片。
class RecordsListCard extends StatelessWidget {
  const RecordsListCard({
    super.key,
    required this.items,
  });

  final List<RecordItemModel> items;

  static const _dividerColor = Color(0xFFE3EFFF);

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                thickness: 1,
                color: _dividerColor,
              ),
            _RecordListItem(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _RecordListItem extends StatelessWidget {
  const _RecordListItem({required this.item});

  final RecordItemModel item;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                  item.userName,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: brandBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.displayDate,
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
          Text(
            'RM${item.displayAmount}',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 400)],
              color: brandBlue,
            ),
          ),
        ],
      ),
    );
  }
}
