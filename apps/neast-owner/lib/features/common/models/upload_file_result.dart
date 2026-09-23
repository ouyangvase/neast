/// 文件上传接口返回结果。
class UploadFileResult {
  const UploadFileResult({
    required this.url,
    required this.path,
    required this.name,
  });

  final String url;
  final String path;
  final String name;

  factory UploadFileResult.fromJson(Map<String, dynamic> json) {
    return UploadFileResult(
      url: json['url']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
