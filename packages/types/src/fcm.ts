import type { ApiClient } from './client';
import type { AddFcmTokenBody, DeleteFcmTokenBody } from './contracts/common';

export interface FcmOptions {
  /** Defaults to true — push registration must never break login/logout flows. */
  swallowErrors?: boolean;
  /** Per-call timeout; defaults to 3000ms (legacy parity with the Flutter apps). */
  timeoutMs?: number;
}

/**
 * POST {prefix}/push/add-fcm-token — call right after login, once the FCM
 * token is available. Fire-and-forget by default.
 */
export async function registerFcmToken(
  client: ApiClient,
  token: string,
  platform?: AddFcmTokenBody['platform'],
  options: FcmOptions = {},
): Promise<void> {
  const { swallowErrors = true, timeoutMs = 3000 } = options;
  try {
    const body: AddFcmTokenBody = platform ? { token, platform } : { token };
    await client.post('push/add-fcm-token', body, { timeoutMs });
  } catch (error) {
    if (!swallowErrors) {
      throw error;
    }
  }
}

/**
 * POST {prefix}/push/delete-fcm-token — call BEFORE clearing the session on
 * logout (the endpoint requires auth). Fire-and-forget by default.
 */
export async function unregisterFcmToken(
  client: ApiClient,
  token: string,
  options: FcmOptions = {},
): Promise<void> {
  const { swallowErrors = true, timeoutMs = 3000 } = options;
  try {
    const body: DeleteFcmTokenBody = { token };
    await client.post('push/delete-fcm-token', body, { timeoutMs });
  } catch (error) {
    if (!swallowErrors) {
      throw error;
    }
  }
}
