import 'package:neast/core/deep_link/deep_link_parser.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareMerchant({
  required int merchantId,
  required String merchantName,
}) async {
  final url = DeepLinkParser.merchantShareUrl(merchantId);
  final name = merchantName.trim().isEmpty ? 'this merchant' : merchantName.trim();

  await SharePlus.instance.share(
    ShareParams(text: 'Check out $name on neast\n$url'),
  );
}
