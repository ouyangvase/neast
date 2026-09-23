import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/notification/models/notification_model.dart';

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
            color: Color(0x1A000000),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'HG',
                    fontSize: 16,
                    color: Colors.black,
                    fontVariations: [FontVariation('wght', 500)],
                    height: 1.4,
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
            style: const TextStyle(
              fontFamily: 'HG',
              fontSize: 12,
              color: Colors.black,
              fontVariations: [FontVariation('wght', 400)],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item.displayDate,
              style: TextStyle(
                fontFamily: 'HG',
                fontSize: 11,
                color: brandBlue,
                fontVariations: const [FontVariation('wght', 400)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
