import { router } from 'expo-router';

import { sessionStore } from '@neast/types';
import { Toast } from '@neast/ui-mobile';

import { drainPendingRoute, peekPendingRoute } from '../stores/pending-route';
import { useTabsStore } from '../stores/tabs';
import { setLogoutHandler } from './api';
import { unregisterPushToken } from './push';
import { queryClient } from './query';

/**
 * Full local logout (authProvider.notifier.logout parity): unregister the FCM
 * token (fire-and-forget), clear the session, wipe cached user state, reset
 * the tab and land on /login.
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

/** Post-login / post-profile navigation (navigateAfterAuth parity). */
export function navigateAfterAuth(): void {
  const pending = drainPendingRoute();
  useTabsStore.getState().reset();
  if (pending) {
    // Land on the tab shell first for a sane back stack, then open the link.
    router.replace('/');
    setTimeout(() => router.push(pending), 80);
    return;
  }
  router.replace('/');
}

/** Splash exit (navigateAfterSplash parity). */
export function navigateAfterSplash(): void {
  const pending = peekPendingRoute();
  if (pending && !sessionStore.getState().isLoggedIn) {
    // Stash stays — replayed by navigateAfterAuth after login.
    router.replace('/login');
    return;
  }
  router.replace('/');
}
