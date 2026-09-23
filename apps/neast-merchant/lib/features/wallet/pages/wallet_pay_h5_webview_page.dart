import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

String _browserLikeUserAgent() {
  if (Platform.isIOS) {
    return 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1';
  }
  return 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';
}

/// Fiuu H5 支付 WebView。
class WalletPayH5WebViewPage extends StatefulWidget {
  const WalletPayH5WebViewPage({
    super.key,
    required this.url,
    this.title = 'Payment',
  });

  final String url;
  final String title;

  @override
  State<WalletPayH5WebViewPage> createState() => _WalletPayH5WebViewPageState();
}

class _WalletPayH5WebViewPageState extends State<WalletPayH5WebViewPage> {
  static const _resultPageGracePeriod = Duration(milliseconds: 2500);
  static const _resultProcessingDuration = Duration(milliseconds: 500);
  static const _pendingProcessingDuration = Duration(seconds: 10);

  late final WebViewController _controller;
  bool _isProcessingResult = false;
  Timer? _pendingTimer;
  Timer? _resultTimer;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setUserAgent(_browserLikeUserAgent())
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterSchemeHandler',
        onMessageReceived: (message) {
          _launchExternalUrl(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _checkPaymentResultByUrl,
          onPageFinished: (_) {
            _controller.runJavaScript('''
              (function() {
                window.open = function(url) {
                  if (url && url !== '' &&
                      !url.startsWith('http://') &&
                      !url.startsWith('https://')) {
                    FlutterSchemeHandler.postMessage(url);
                    return null;
                  }
                  window.location.href = url;
                  return null;
                };
              })();
            ''');
          },
          onNavigationRequest: (request) {
            _checkPaymentResultByUrl(request.url);
            final uri = Uri.tryParse(request.url);
            if (uri != null &&
                uri.scheme != 'http' &&
                uri.scheme != 'https' &&
                uri.scheme != 'about' &&
                uri.scheme != 'blob') {
              _launchExternalUrl(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    _pendingTimer?.cancel();
    _resultTimer?.cancel();
    super.dispose();
  }

  void _checkPaymentResultByUrl(String url) {
    if (_isProcessingResult) return;

    if (url.contains('/pay_success.html')) {
      _handleSuccessPage();
    } else if (url.contains('/pay_failed.html')) {
      _handleFailPage();
    } else if (url.contains('/pay_pending.html')) {
      _handlePendingPage();
    }
  }

  void _handleSuccessPage() {
    _schedulePaymentResult(0);
  }

  void _handleFailPage() {
    _schedulePaymentResult(2);
  }

  void _handlePendingPage() {
    if (_isProcessingResult) return;
    _schedulePaymentResult(1, processingDuration: _pendingProcessingDuration);
  }

  void _schedulePaymentResult(
    int resultCode, {
    Duration processingDuration = _resultProcessingDuration,
  }) {
    setState(() => _isProcessingResult = true);
    _pendingTimer?.cancel();
    _resultTimer?.cancel();

    _resultTimer = Timer(_resultPageGracePeriod, () {
      if (!mounted) return;

      EasyLoading.show(status: 'Processing...');
      _pendingTimer = Timer(processingDuration, () {
        EasyLoading.dismiss();
        if (mounted) {
          Navigator.of(context).pop<int>(resultCode);
        }
      });
    });
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      if (url.startsWith('intent://')) {
        await _launchIntentUrl(url);
        return;
      }
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (url.startsWith('intent://')) {
        await _launchIntentFallback(url);
      }
    }
  }

  Future<void> _launchIntentUrl(String intentUrl) async {
    final schemeMatch = RegExp(r'scheme=([^;#]+)').firstMatch(intentUrl);
    if (schemeMatch != null) {
      final scheme = schemeMatch.group(1)!;
      final path = intentUrl.replaceFirst('intent://', '');
      final endIdx = path.indexOf('#Intent');
      final cleanPath = endIdx > 0 ? path.substring(0, endIdx) : path;
      try {
        final appUri = Uri.parse('$scheme://$cleanPath');
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      } catch (_) {}
    }
    await _launchIntentFallback(intentUrl);
  }

  Future<void> _launchIntentFallback(String intentUrl) async {
    final fallbackMatch =
        RegExp(r'S\.browser_fallback_url=([^;#]+)').firstMatch(intentUrl);
    if (fallbackMatch != null) {
      try {
        final fallbackUri =
            Uri.parse(Uri.decodeComponent(fallbackMatch.group(1)!));
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
  }

  void _onCancelPayment() {
    _pendingTimer?.cancel();
    _resultTimer?.cancel();
    EasyLoading.dismiss();
    Navigator.of(context).pop<int>();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = Theme.of(context).colorScheme.primary;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9F6),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: const Color(0xFFE3EFFF),
          foregroundColor: brandBlue,
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: _onCancelPayment,
              child: const Text('Back'),
            ),
          ],
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
