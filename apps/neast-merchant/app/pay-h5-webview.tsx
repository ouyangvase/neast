import { router, useLocalSearchParams } from 'expo-router';

import { FiuuH5WebView } from '@neast/ui-mobile';

import { clearH5Callbacks, getH5Callbacks } from '@/lib/callbacks';

/**
 * Fiuu H5 payment page (wallet_pay_h5_webview_page parity). Callers stash
 * result callbacks via `openH5WebView`; this route invokes them and pops.
 */
export default function PayH5WebViewRoute() {
  const params = useLocalSearchParams<{ url: string; title: string }>();

  if (!params.url) {
    return null;
  }

  return (
    <FiuuH5WebView
      url={params.url}
      title={params.title ?? 'Payment'}
      onResult={(result) => {
        const callbacks = getH5Callbacks();
        clearH5Callbacks();
        router.back();
        callbacks?.onResult(result);
      }}
      onCancel={() => {
        const callbacks = getH5Callbacks();
        clearH5Callbacks();
        router.back();
        callbacks?.onCancel?.();
      }}
    />
  );
}
