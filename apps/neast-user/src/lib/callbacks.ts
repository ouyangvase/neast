import { router } from 'expo-router';

import type { FiuuPaymentResult } from '@neast/ui-mobile';

/**
 * Screen-result callbacks. The Flutter app pops routes with a result value
 * (`/scanner` → scanned string, `/pay-h5-webview` → Fiuu result code); Expo
 * Router has no pop-with-result, so callers stash a callback here before
 * pushing and the pushed screen invokes it.
 */

// ---- QR scanner ----

let scannerCallback: ((value: string) => void) | null = null;

export function openScanner(onScanned: (value: string) => void): void {
  scannerCallback = onScanned;
  router.push('/scanner');
}

/** Called by the scanner route once a value is scanned. */
export function handleScanned(value: string): void {
  const callback = scannerCallback;
  scannerCallback = null;
  callback?.(value);
}

// ---- Fiuu H5 WebView ----

export interface H5Callbacks {
  onResult: (result: FiuuPaymentResult) => void;
  onCancel?: () => void;
}

let h5Callbacks: H5Callbacks | null = null;

export function openH5WebView(url: string, title: string, callbacks: H5Callbacks): void {
  h5Callbacks = callbacks;
  router.push({ pathname: '/pay-h5-webview', params: { url, title } });
}

export function getH5Callbacks(): H5Callbacks | null {
  return h5Callbacks;
}

export function clearH5Callbacks(): void {
  h5Callbacks = null;
}
