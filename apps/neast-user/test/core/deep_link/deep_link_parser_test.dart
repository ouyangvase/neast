import 'package:neast/core/deep_link/deep_link_parser.dart';
import 'package:test/test.dart';

void main() {
  group('DeepLinkParser', () {
    test('parses custom scheme merchant link', () {
      final route = DeepLinkParser.parseRoute(
        Uri.parse('neastuser://merchant/42'),
      );
      expect(route, '/merchant/42');
    });

    test('parses custom scheme with path prefix', () {
      final route = DeepLinkParser.parseRoute(
        Uri.parse('neastuser:///merchant/42'),
      );
      expect(route, '/merchant/42');
    });

    test('repairs broken /id route', () {
      expect(
        DeepLinkParser.repairBrokenMerchantRoute('/2'),
        '/merchant/2',
      );
      expect(
        DeepLinkParser.repairBrokenMerchantRoute('/merchant/2'),
        isNull,
      );
    });

    test('parses https merchant share link', () {
      final route = DeepLinkParser.parseRoute(
        Uri.parse('https://api.neast.my/merchant/42'),
      );
      expect(route, '/merchant/42');
    });

    test('returns null for unsupported link', () {
      final route = DeepLinkParser.parseRoute(
        Uri.parse('https://api.neast.my/invite'),
      );
      expect(route, isNull);
    });

    test('detects merchant detail route', () {
      expect(DeepLinkParser.isMerchantDetailRoute('/merchant/12'), isTrue);
      expect(DeepLinkParser.isMerchantDetailRoute('/merchants'), isFalse);
    });

    test('builds merchant share url', () {
      expect(
        DeepLinkParser.merchantShareUrl(7),
        'https://api.neast.my/merchant/7',
      );
    });
  });
}
