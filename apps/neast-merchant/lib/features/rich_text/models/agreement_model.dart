/// 协议内容。
class AgreementModel {
  const AgreementModel({
    required this.id,
    required this.title,
    required this.content,
  });

  final int id;
  final String title;
  final String content;

  factory AgreementModel.fromJson(Map<String, dynamic> json) {
    return AgreementModel(
      id: _readInt(json['id']),
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
