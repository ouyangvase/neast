import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

enum _ReferMilestoneState {
  completed,
  current,
  upcoming,
}

class _ReferMilestone {
  const _ReferMilestone({
    required this.label,
    required this.state,
  });

  final String label;
  final _ReferMilestoneState state;
}

/// 推荐页 Reward Milestones 进度卡片。
class ReferMilestonesCard extends StatelessWidget {
  const ReferMilestonesCard({super.key});

  static const _nodeSize = 28.0;
  static const _lineTop = (_nodeSize - 2) / 2;

  static const _milestones = [
    _ReferMilestone(
      label: 'First Invite',
      state: _ReferMilestoneState.completed,
    ),
    _ReferMilestone(
      label: 'Social Starter',
      state: _ReferMilestoneState.current,
    ),
    _ReferMilestone(
      label: 'Power Sharer',
      state: _ReferMilestoneState.upcoming,
    ),
    _ReferMilestone(
      label: 'Ambassador',
      state: _ReferMilestoneState.upcoming,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    const milestones = _milestones;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Text(
            'Reward Milestones',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = milestones.length;
              final columnWidth = constraints.maxWidth / count;
              final segmentWidth = columnWidth - _nodeSize;

              return Stack(
                children: [
                  for (var i = 0; i < count - 1; i++)
                    Positioned(
                      left: columnWidth * (i + 0.5) + _nodeSize / 2,
                      top: _lineTop,
                      width: segmentWidth,
                      child: Container(
                        height: 2,
                        color: milestones[i].state ==
                                _ReferMilestoneState.completed
                            ? brandBlue
                            : brandBlue.withValues(alpha: 0.15),
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < count; i++)
                        Expanded(
                          child: _MilestoneColumn(
                            milestone: milestones[i],
                            index: i + 1,
                            brandBlue: brandBlue,
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MilestoneColumn extends StatelessWidget {
  const _MilestoneColumn({
    required this.milestone,
    required this.index,
    required this.brandBlue,
  });

  final _ReferMilestone milestone;
  final int index;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: _MilestoneNode(
            state: milestone.state,
            index: index,
            brandBlue: brandBlue,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            milestone.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: brandBlue.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

class _MilestoneNode extends StatelessWidget {
  const _MilestoneNode({
    required this.state,
    required this.index,
    required this.brandBlue,
  });

  final _ReferMilestoneState state;
  final int index;
  final Color brandBlue;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _ReferMilestoneState.completed:
        return Container(
          width: ReferMilestonesCard._nodeSize,
          height: ReferMilestonesCard._nodeSize,
          decoration: BoxDecoration(
            color: brandBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
        );
      case _ReferMilestoneState.current:
        return Container(
          width: ReferMilestonesCard._nodeSize,
          height: ReferMilestonesCard._nodeSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: brandBlue, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: brandBlue,
            ),
          ),
        );
      case _ReferMilestoneState.upcoming:
        return Container(
          width: ReferMilestonesCard._nodeSize,
          height: ReferMilestonesCard._nodeSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: brandBlue.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: brandBlue.withValues(alpha: 0.35),
            ),
          ),
        );
    }
  }
}
