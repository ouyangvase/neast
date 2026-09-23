import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

class _ActionStat {
  const _ActionStat(this.label, this.value);
  final String label;
  final String value;
}

/// 今日待办卡片。
class HomeNeedActionCard extends StatelessWidget {
  const HomeNeedActionCard({
    super.key,
    required this.overdue,
    required this.dueSoon,
    required this.needAck,
    required this.bindReq,
    required this.tasksWaitingText,
  });

  final int overdue;
  final int dueSoon;
  final int needAck;
  final int bindReq;
  final String tasksWaitingText;

  List<_ActionStat> get _stats => [
        _ActionStat('Overdue', '$overdue'),
        _ActionStat('Due Soon', '$dueSoon'),
        _ActionStat('Need Ack', '$needAck'),
        _ActionStat('Bind Req', '$bindReq'),
      ];

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today Need Action',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: HomeColors.label,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  tasksWaitingText,
                  style: TextStyle(
                    fontFamily: 'FD',
                    fontSize: 18,
                    fontVariations: [FontVariation('wght', 500)],
                    color: brandBlue,
                  ),
                ),
              ),
              Image.asset(HomeAssets.taskWarning, width: 16, height: 16),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var i = 0; i < _stats.length; i++) ...[
                  if (i > 0)
                    const VerticalDivider(
                      width: 30,
                      thickness: 1,
                      color: Color(0xFFECF4FF),
                    ),
                  Expanded(
                    child: _StatColumn(stat: _stats[i], brandBlue: brandBlue),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.stat, required this.brandBlue});

  final _ActionStat stat;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stat.label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 400)],
            color: HomeColors.label,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          stat.value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'FD',
            fontVariations: [FontVariation('wght', 500)],
            color: brandBlue,
          ),
        ),
      ],
    );
  }
}
