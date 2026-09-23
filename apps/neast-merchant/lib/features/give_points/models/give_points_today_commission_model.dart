class GivePointsTodayCommissionModel {
  const GivePointsTodayCommissionModel({
    required this.points,
    required this.commissionRm,
  });

  final int points;
  final String commissionRm;

  factory GivePointsTodayCommissionModel.fromJson(Map<String, dynamic> json) {
    return GivePointsTodayCommissionModel(
      points: json['points'] as int? ?? 0,
      commissionRm: json['commission_rm']?.toString() ?? '0.00',
    );
  }

  String get formattedCommission {
    final amount = double.tryParse(commissionRm);
    if (amount == null) {
      return commissionRm.isEmpty ? '0.00' : commissionRm;
    }
    return amount.toStringAsFixed(2);
  }
}
