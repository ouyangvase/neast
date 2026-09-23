import { router } from 'expo-router';

import { sessionStore } from '@neast/types';
import { Toast } from '@neast/ui-mobile';

import { useTabsStore } from '../stores/tabs';
import { setLogoutHandler } from './api';
import { unregisterPushToken } from './push';
import { queryClient } from './query';

/**
 * Full local logout (authProvider.notifier.logout parity): unregister the FCM
 * token (fire-and-forget), clear the session, wipe cached state, reset the tab
 * and land on /login.
 */
export async function performLogout(): Promise<void> {
  void unregisterPushToken();
  await sessionStore.getState().clearSession();
  queryClient.clear();
  useTabsStore.getState().reset();
  router.replace('/login');
}

/** Invoked by the API client after an unrecoverable auth failure (session already cleared). */
function handleSessionExpired(): void {
  queryClient.clear();
  useTabsStore.getState().reset();
  Toast.error('Session expired. Please log in again.');
  router.replace('/login');
}

setLogoutHandler(handleSessionExpired);

/** Post-login navigation (navigateAfterAuth parity). */
export function navigateAfterAuth(): void {
  useTabsStore.getState().reset();
  router.replace('/');
}

/** Splash exit (navigateAfterSplash parity) — no guest mode in the merchant app. */
export function navigateAfterSplash(): void {
  router.replace(sessionStore.getState().isLoggedIn ? '/' : '/login');
}
