import 'package:neast/core/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

/// 在 Google Maps 中打开商家位置；未安装 App 时降级到网页或系统地图。
///
/// 优先使用 [address] 搜索（地图上会显示可读地址），仅当地址为空时才用经纬度。
Future<void> openMerchantInGoogleMaps({
  required String address,
  double? latitude,
  double? longitude,
}) async {
  final trimmedAddress = address.trim();
  final hasCoordinates = latitude != null && longitude != null;
  final useAddress = trimmedAddress.isNotEmpty;

  if (!useAddress && !hasCoordinates) {
    ToastUtil.show('Location not available');
    return;
  }

  final encodedAddress = Uri.encodeComponent(trimmedAddress);
  final googleMapsAppUri = useAddress
      ? Uri.parse('comgooglemaps://?q=$encodedAddress')
      : Uri.parse('comgooglemaps://?q=$latitude,$longitude');

  if (await canLaunchUrl(googleMapsAppUri)) {
    final launched = await launchUrl(
      googleMapsAppUri,
      mode: LaunchMode.externalApplication,
    );
    if (launched) {
      return;
    }
  }

  if (!useAddress && hasCoordinates) {
    final geoUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
    if (await canLaunchUrl(geoUri)) {
      final launched = await launchUrl(
        geoUri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        return;
      }
    }
  }

  final webQuery = useAddress ? encodedAddress : '$latitude,$longitude';
  final webUri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$webQuery',
  );

  final launched = await launchUrl(
    webUri,
    mode: LaunchMode.externalApplication,
  );
  if (!launched) {
    ToastUtil.show('Unable to open maps');
  }
}
