import { useEffect } from 'react';
import { KeyboardAvoidingView, Platform, StyleSheet } from 'react-native';
import { QueryClientProvider } from '@tanstack/react-query';
import { Stack, router, usePathname } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { sessionStore, useIsLoggedIn, useSessionStatus } from '@neast/types';
import { ToastHost, UiThemeProvider } from '@neast/ui-mobile';

import '../src/lib/auth'; // registers the session-expired logout handler
import { queryClient } from '../src/lib/query';

void SplashScreen.preventAutoHideAsync();

/**
 * No guest mode (app_router.dart redirect parity): everything except the auth
 * routes redirects to /login when logged out.
 */
const PUBLIC_PATHS = new Set(['/splash', '/login', '/verify']);

export default function RootLayout() {
  const pathname = usePathname();
  const sessionStatus = useSessionStatus();
  const isLoggedIn = useIsLoggedIn();

  // Release the native splash from the root. preventAutoHide blocks drawing
  // until hide, and the splash route is not always the first screen.
  useEffect(() => {
    void sessionStore.getState().hydrate();
    void SplashScreen.hideAsync();
  }, []);

  // Auth guard.
  useEffect(() => {
    if (sessionStatus !== 'ready' || isLoggedIn) {
      return;
    }
    if (PUBLIC_PATHS.has(pathname)) {
      return;
    }
    router.replace('/login');
  }, [pathname, sessionStatus, isLoggedIn]);

  return (
    <SafeAreaProvider>
      <QueryClientProvider client={queryClient}>
        <UiThemeProvider app="owner">
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
