import { Platform } from 'react-native';
import * as Notifications from 'expo-notifications';
import { router } from 'expo-router';

import { registerFcmToken, sessionStore, unregisterFcmToken } from '@neast/types';

import { api } from './api';
import { queryClient } from './query';

/**
 * Push notifications (push_notification_service.dart parity).
 *
 * NOTE: `getDevicePushTokenAsync` returns the native FCM registration token on
 * Android (google-services.json wired via app config). On iOS it returns the
 * APNs token — a true FCM token on iOS would require @react-native-firebase,
 * which this rebuild intentionally avoids (see PARITY.md).
 */

let lastToken: string | null = null;
let initialized = false;

function platform(): 'ios' | 'android' {
  return Platform.OS === 'ios' ? 'ios' : 'android';
}

/** Tap/foreground handling: clear badge, then navigate by `data.type`. */
function handleNotificationResponse(response: Notifications.NotificationResponse): void {
  void Notifications.setBadgeCountAsync(0);
  const data = response.notification.request.content.data;
  const type = typeof data?.type === 'string' ? data.type : '';
  if (!sessionStore.getState().isLoggedIn) {
    router.replace('/login');
    return;
  }
  if (type === 'PointAdd') {
    router.push('/points/history');
  } else if (type === 'Coupon') {
    router.push('/coupon/my-coupons');
  } else {
    router.push('/notification');
  }
}

/** Initialized from the main screen when logged in. Safe to call repeatedly. */
export async function initPushNotifications(): Promise<void> {
  if (initialized) {
    return;
  }
  initialized = true;

  Notifications.setNotificationHandler({
    handleNotification: async () => ({
      shouldShowAlert: true,
      shouldPlaySound: true,
      shouldSetBadge: false,
      shouldShowBanner: true,
      shouldShowList: true,
    }),
  });

  Notifications.addNotificationResponseReceivedListener(handleNotificationResponse);
  Notifications.addNotificationReceivedListener(() => {
    void queryClient.invalidateQueries({ queryKey: ['has-unread'] });
  });

  const current = await Notifications.getPermissionsAsync();
  const permissions = current.granted ? current : await Notifications.requestPermissionsAsync();
  if (!permissions.granted) {
    return;
  }

  try {
    const token = await Notifications.getDevicePushTokenAsync();
    lastToken = String(token.data);
    await registerFcmToken(api, lastToken, platform());
  } catch {
    // Push unavailable (simulator / Expo Go / missing FCM config) — non-fatal.
  }

  Notifications.addPushTokenListener((token) => {
    lastToken = String(token.data);
    if (sessionStore.getState().isLoggedIn && lastToken) {
      void registerFcmToken(api, lastToken, platform());
    }
  });
}

/** Logout parity: POST delete-fcm-token BEFORE the session is cleared (endpoint needs auth). */
export async function unregisterPushToken(): Promise<void> {
  if (!lastToken) {
    return;
  }
  const token = lastToken;
  lastToken = null;
  await unregisterFcmToken(api, token);
}
