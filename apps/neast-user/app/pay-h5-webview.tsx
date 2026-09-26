import { useLayoutEffect } from 'react';
import { router, useLocalSearchParams, useNavigation } from 'expo-router';

import { FiuuH5WebView, PageHeader } from '@neast/ui-mobile';

import { clearH5Callbacks, getH5Callbacks } from '@/lib/callbacks';
import { Screen } from '@/components/Screen';

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

  const cancel = () => {
    const callbacks = getH5Callbacks();
    clearH5Callbacks();
    router.back();
    callbacks?.onCancel?.();
  };

  return (
    <Screen edges={['bottom']}>
      <PageHeader title={params.title} onBack={cancel} />
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
