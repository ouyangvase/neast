import { useEffect } from 'react';
import { KeyboardAvoidingView, Platform, StyleSheet } from 'react-native';
import { QueryClientProvider } from '@tanstack/react-query';
import { Stack, router, usePathname } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { sessionStore, useIsLoggedIn, useSessionStatus } from '@neast/types';
import { ToastHost, UiThemeProvider } from '@neast/ui-mobile';

import '../src/lib/auth'; // registers the session-expired logout handler
import { isMerchantDetailPath } from '../src/lib/deep-links';
import { queryClient } from '../src/lib/query';
import { stashPendingRoute } from '../src/stores/pending-route';

void SplashScreen.preventAutoHideAsync();

/**
 * Guest-mode allowlist (app_router.dart redirect parity). Everything else
 * redirects to /login; merchant-detail links are stashed for post-auth replay.
 * Matches the documented allowlist exactly — `/coupon/detail` requires auth.
 */
const GUEST_PATHS = new Set([
  '/',
  '/splash',
  '/login',
  '/verify',
  '/full-data',
  '/rich-text',
  '/merchants',
  '/merchants/map',
  '/coupon',
  '/properties',
]);

export default function RootLayout() {
  const pathname = usePathname();
  const sessionStatus = useSessionStatus();
  const isLoggedIn = useIsLoggedIn();

  // Splash gate: hydrate the session once at app start, and release the
  // native splash here. The splash route is not always the first screen
  // (dev-client launch opens `/`), and leaving preventAutoHide set blocks
  // every frame — the window stays black.
  useEffect(() => {
    void sessionStore.getState().hydrate();
    void SplashScreen.hideAsync();
  }, []);

  // Guest-mode guard.
  useEffect(() => {
    if (sessionStatus !== 'ready' || isLoggedIn) {
      return;
    }
    if (GUEST_PATHS.has(pathname)) {
      return;
    }
    if (isMerchantDetailPath(pathname)) {
      stashPendingRoute(pathname);
    }
    router.replace('/login');
  }, [pathname, sessionStatus, isLoggedIn]);

  return (
    <SafeAreaProvider>
      <QueryClientProvider client={queryClient}>
        <UiThemeProvider app="user">
          <KeyboardAvoidingView
            style={styles.flex}
            behavior={Platform.OS === 'ios' ? 'padding' : undefined}
          >
            <Stack screenOptions={{ headerShown: false }} initialRouteName="splash" />
            <ToastHost />
          </KeyboardAvoidingView>
        </UiThemeProvider>
      </QueryClientProvider>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  flex: {
    flex: 1,
  },
});
