import { useEffect } from 'react';
import { KeyboardAvoidingView, Platform, StyleSheet } from 'react-native';
import { QueryClientProvider } from '@tanstack/react-query';
import { Stack, router, usePathname } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { sessionStore, useIsLoggedIn, useSessionStatus } from '@neast/types';
import { ToastHost, UiThemeProvider, useBrandFonts } from '@neast/ui-mobile';

import '../src/lib/auth'; // registers the session-expired logout handler
import { queryClient } from '../src/lib/query';

void SplashScreen.preventAutoHideAsync();

/**
 * Auth guard (app_router.dart redirect parity): logged-out users are sent to
 * /login; only /login and /splash are reachable while logged out. The merchant
 * app has no guest mode and no register/verify routes.
 */
const PUBLIC_PATHS = new Set(['/login', '/splash']);

export default function RootLayout() {
  const { loaded: fontsLoaded } = useBrandFonts();
  const pathname = usePathname();
  const sessionStatus = useSessionStatus();
  const isLoggedIn = useIsLoggedIn();

  // Splash gate: hydrate the session once at app start.
  useEffect(() => {
    void sessionStore.getState().hydrate();
  }, []);

  // Logged-out redirect.
  useEffect(() => {
    if (sessionStatus !== 'ready' || isLoggedIn) {
      return;
    }
    if (PUBLIC_PATHS.has(pathname)) {
      return;
    }
    router.replace('/login');
  }, [pathname, sessionStatus, isLoggedIn]);

  if (!fontsLoaded) {
    return null;
  }

  return (
    <SafeAreaProvider>
      <QueryClientProvider client={queryClient}>
        <UiThemeProvider app="merchant">
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
