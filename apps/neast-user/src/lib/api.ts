import { ApiError, createApiClient, type LogoutReason } from '@neast/types';

/**
 * The app's API client (`/app` prefix). Base URL comes from
 * `EXPO_PUBLIC_API_URL`, defaulting to `http://10.0.2.2:9512`
 * (use `http://10.0.2.2:8000` for the bundled mock-api).
 *
 * Envelope/refresh quirks (raw token header, business-400 refresh with the
 * refresh token as a query param, 200ms GET delay) live in @neast/types.
 */
let logoutHandler: ((reason: LogoutReason) => void) | null = null;

/** Registered by src/lib/auth.ts (avoids an api ↔ auth import cycle). */
export function setLogoutHandler(handler: (reason: LogoutReason) => void): void {
  logoutHandler = handler;
}

export const api = createApiClient({
  prefix: '/app',
  onLogout: (reason) => logoutHandler?.(reason),
});

/** User-facing message for any thrown error (ApiError carries the server message). */
export function apiErrorMessage(
  error: unknown,
  fallback = 'Something went wrong. Please try again.',
): string {
  if (error instanceof ApiError && error.message) {
    return error.message;
  }
  if (error instanceof Error && error.message) {
    return error.message;
  }
  return fallback;
}
