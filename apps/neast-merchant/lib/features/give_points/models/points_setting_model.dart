class PointsSettingModel {
  const PointsSettingModel({
    required this.yuanToPoints,
  });

  final int yuanToPoints;

  factory PointsSettingModel.fromJson(Map<String, dynamic> json) {
    return PointsSettingModel(
      yuanToPoints: json['yuan_to_points'] as int? ?? 1,
    );
  }
}
