import { useEffect, useRef } from 'react';
import { BackHandler, Linking, Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import WebView from 'react-native-webview';
import type {
  ShouldStartLoadRequest,
  WebViewNavigation,
} from 'react-native-webview/lib/WebViewTypes';

import { coreColors } from '../tokens/colors';
import { spacing } from '../tokens/layout';
import { textStyles } from '../tokens/typography';
import { Chevron } from './Chevron';

/** Payment outcome derived from the Fiuu return URL (purely URL-substring based). */
export type FiuuPaymentResult = 'success' | 'pending' | 'failed';

export interface FiuuH5WebViewProps {
  /** `paymentUrl` returned by the top-up / pay create endpoints. */
  url: string;
  title?: string;
  /**
   * Fired once, after the 2.5s grace period, when the return URL contains
   * `/pay_success.html` / `pay_pending` / `pay_failed`.
   */
  onResult: (result: FiuuPaymentResult) => void;
  /** User left before any result was detected (back button / hardware back). */
  onCancel?: () => void;
  /** Grace period letting the result page render before reporting. Default: 2500ms. */
  gracePeriodMs?: number;
}

/** Browser-like user agents (from the Flutter `wallet_pay_h5_webview_page`). */
const USER_AGENT =
  Platform.OS === 'ios'
    ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1'
    : 'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

function detectResult(url: string): FiuuPaymentResult | null {
  if (url.includes('/pay_success.html')) return 'success';
  if (url.includes('pay_pending')) return 'pending';
  if (url.includes('pay_failed')) return 'failed';
  return null;
}

function isWebUrl(url: string): boolean {
  return /^(https?|about|blob):/i.test(url);
}

/**
 * Parse an Android `intent://` URL: prefer the embedded `scheme=` deep link,
 * falling back to `S.browser_fallback_url` when the app is not installed.
 */
async function openIntentUrl(url: string): Promise<void> {
  const schemeMatch = /;scheme=([^;]+)/.exec(url);
  const fallbackMatch = /;S\.browser_fallback_url=([^;]+)/.exec(url);
  const fallback = fallbackMatch?.[1] ? decodeURIComponent(fallbackMatch[1]) : null;

  let schemeUrl: string | null = null;
  if (schemeMatch?.[1]) {
    const path = url.slice('intent://'.length).split('#Intent')[0];
    schemeUrl = `${schemeMatch[1]}://${path ?? ''}`;
  }

  try {
    if (schemeUrl) {
      await Linking.openURL(schemeUrl);
      return;
    }
  } catch {
    // App not installed — try the fallback below.
  }
  if (fallback) {
    try {
      await Linking.openURL(fallback);
    } catch {
      // Nowhere to go — ignore.
    }
  }
}

/**
 * Forward `window.open` of non-http(s) schemes into a navigation so the
 * external-scheme handler picks it up (FlutterSchemeHandler equivalent).
 */
const WINDOW_OPEN_FORWARDING_JS = `
  (function() {
    var origOpen = window.open;
    window.open = function(u) {
      if (u && !/^(https?|about|blob):/i.test(u)) {
        window.location.href = u;
        return null;
      }
      return origOpen ? origOpen.apply(window, arguments) : null;
    };
  })();
  true;
`;

/** Open a non-http(s) scheme (tng://, grab://, …) in the external app. */
function openExternalScheme(url: string) {
  if (url.startsWith('intent://')) {
    void openIntentUrl(url);
    return;
  }
  Linking.openURL(url).catch(() => {
    // No handler installed — ignore.
  });
}

/**
 * Fiuu H5 hosted-checkout WebView (webview_flutter screen equivalent).
 *
 * Replicates the Flutter contract exactly:
 *  - browser-like UA, JS enabled, `window.open` forwards non-http(s) schemes;
 *  - non http/https/about/blob navigations are opened externally (incl.
 *    Android `intent://` with `scheme=` extraction + `S.browser_fallback_url`);
 *  - result detection is purely URL-substring based, reported once after a
 *    2.5s grace period; back/close reports `onCancel`.
 */
export function FiuuH5WebView({
  url,
  title = 'Payment',
  onResult,
  onCancel,
  gracePeriodMs = 2500,
}: FiuuH5WebViewProps) {
  const resultFiredRef = useRef(false);
  const graceTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const fireResult = (result: FiuuPaymentResult) => {
    if (resultFiredRef.current) return;
    resultFiredRef.current = true;
    if (graceTimerRef.current) clearTimeout(graceTimerRef.current);
    graceTimerRef.current = setTimeout(() => onResult(result), gracePeriodMs);
  };

  useEffect(
    () => () => {
      if (graceTimerRef.current) clearTimeout(graceTimerRef.current);
    },
    [],
  );

  // Hardware back = cancel (PopScope canPop: false equivalent).
  useEffect(() => {
    if (Platform.OS !== 'android') return;
    const sub = BackHandler.addEventListener('hardwareBackPress', () => {
      onCancel?.();
      return true;
    });
    return () => sub.remove();
  }, [onCancel]);

  const handleNavigation = (navUrl: string): boolean => {
    const result = detectResult(navUrl);
    if (result) {
      fireResult(result);
      return true;
    }
    if (!isWebUrl(navUrl)) {
      openExternalScheme(navUrl);
      return false;
    }
    return true;
  };

  const onShouldStartLoadWithRequest = (request: ShouldStartLoadRequest) =>
    handleNavigation(request.url);

  const onNavigationStateChange = (navState: WebViewNavigation) => {
    const result = detectResult(navState.url);
    if (result) fireResult(result);
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Pressable
          onPress={onCancel}
          accessibilityRole="button"
          accessibilityLabel="Back"
          hitSlop={12}
          style={styles.back}
        >
          <Chevron direction="left" />
        </Pressable>
        <Text style={styles.title} numberOfLines={1}>
          {title}
        </Text>
        <View style={styles.back} />
      </View>
      <WebView
        source={{ uri: url }}
        userAgent={USER_AGENT}
        javaScriptEnabled
        domStorageEnabled
        onShouldStartLoadWithRequest={onShouldStartLoadWithRequest}
        onNavigationStateChange={onNavigationStateChange}
        injectedJavaScript={WINDOW_OPEN_FORWARDING_JS}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: coreColors.white,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    minHeight: 52,
    paddingHorizontal: spacing.lg,
    backgroundColor: coreColors.appBarBackground,
  },
  back: {
    minWidth: 24,
    padding: spacing.xs,
  },
  title: {
    ...textStyles.heading3,
    flex: 1,
    textAlign: 'center',
  },
});
