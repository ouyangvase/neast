import 'package:flutter/material.dart';
import 'package:neast/features/tent_score/models/tent_score_model.dart';

/// Tent Score 明细列表（左标签 / 右值，行间细分隔线）。
class TentScoreStatsList extends StatelessWidget {
  const TentScoreStatsList({super.key, required this.model});

  final TentScoreModel model;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('On-time Payments', '${model.onTimePayments}'),
      ('Late Payments', '${model.latePayments}'),
      ('Total Paid', model.totalPaid),
      ('Verified leases', '${model.verifiedLeases}'),
      ('Since', model.since),
    ];

    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          _StatRow(label: rows[i].$1, value: rows[i].$2),
          if (i != rows.length - 1) const Divider(height: 1, color: Color(0xFFEDEFF2)),
        ],
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 500)],
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 600)],
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
