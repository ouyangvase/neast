import { useLayoutEffect } from 'react';
import { router, useLocalSearchParams, useNavigation } from 'expo-router';

import { FiuuH5WebView } from '@neast/ui-mobile';

import { clearH5Callbacks, getH5Callbacks } from '../src/lib/callbacks';
import { PageHeader } from '../src/components/PageHeader';
import { Screen } from '../src/components/Screen';

/**
 * Fiuu H5 payment page (wallet_pay_h5_webview_page parity). Callers stash
 * result callbacks via `openH5WebView`; this route invokes them and pops.
 */
export default function PayH5WebViewRoute() {
  const params = useLocalSearchParams<{ url: string; title: string }>();
  const navigation = useNavigation();

  useLayoutEffect(() => {
    navigation.setOptions({ gestureEnabled: false });
  }, [navigation]);

  if (!params.url) {
    return null;
  }

  const cancel = () => {
    const callbacks = getH5Callbacks();
    clearH5Callbacks();
    router.back();
    callbacks?.onCancel?.();
  };

  return (
    <Screen edges={['bottom']}>
      <PageHeader title={params.title ?? 'Payment'} onBack={cancel} />
      <FiuuH5WebView
        showHeader={false}
        url={params.url}
        onResult={(result) => {
          const callbacks = getH5Callbacks();
          clearH5Callbacks();
          router.back();
          callbacks?.onResult(result);
        }}
        onCancel={cancel}
      />
    </Screen>
  );
}
