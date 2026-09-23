import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/notification/models/notification_model.dart';

/// 通知列表单项卡片。
class NotificationItemCard extends StatelessWidget {
  const NotificationItemCard({
    super.key,
    required this.item,
  });

  final NotificationModel item;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: brandBlue,
                  ),
                ),
              ),
              if (item.isUnread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, left: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4444),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.content,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.displayDate,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: Color(0xFFACC4E5),
            ),
          ),
        ],
      ),
    );
  }
}
