import 'package:neast/core/constants/app_constants.dart';

/// 解析深链 URI 为 App 内路由路径。
abstract final class DeepLinkParser {
  static const _customScheme = 'neastuser';

  /// 将 [uri] 解析为 App 路由，无法识别时返回 null。
  static String? parseRoute(Uri uri) {
    if (uri.scheme == _customScheme) {
      return _parseCustomScheme(uri);
    }

    if (uri.scheme == 'https' || uri.scheme == 'http') {
      return _parseHttpsMerchant(uri);
    }

    return null;
  }

  static String? _parseCustomScheme(Uri uri) {
    // neastuser://merchant/2
    if (uri.host == 'merchant') {
      final id = _parseMerchantId(uri.pathSegments);
      if (id != null) {
        return merchantDetailRoute(id);
      }
    }

    // neastuser:///merchant/2
    final segments = uri.pathSegments;
    if (segments.length >= 2 && segments.first == 'merchant') {
      final id = int.tryParse(segments[1]);
      if (id != null && id > 0) {
        return merchantDetailRoute(id);
      }
    }

    return null;
  }

  static String? _parseHttpsMerchant(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length >= 2 && segments.first == 'merchant') {
      final id = int.tryParse(segments[1]);
      if (id != null && id > 0) {
        return merchantDetailRoute(id);
      }
    }

    return null;
  }

  static int? _parseMerchantId(List<String> segments) {
    if (segments.isEmpty) {
      return null;
    }

    final id = int.tryParse(segments.first);
    if (id == null || id < 1) {
      return null;
    }

    return id;
  }

  static String merchantDetailRoute(int id) => '/merchant/$id';

  static bool isMerchantDetailRoute(String location) {
    return RegExp(r'^/merchant/\d+$').hasMatch(location);
  }

  /// GoRouter 误将 neastuser://merchant/2 解析为 /2 时的兜底修正。
  static String? repairBrokenMerchantRoute(String location) {
    final match = RegExp(r'^/(\d+)$').firstMatch(location);
    if (match == null) {
      return null;
    }

    final id = int.tryParse(match.group(1)!);
    if (id == null || id < 1) {
      return null;
    }

    return merchantDetailRoute(id);
  }

  static String merchantShareUrl(int merchantId) {
    return '${AppConstants.apiBaseUrl}/merchant/$merchantId';
  }
}
