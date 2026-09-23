import { create } from 'zustand';
import type { StoreApi, UseBoundStore } from 'zustand';
import * as SecureStore from 'expo-secure-store';
import { SESSION_STORAGE_KEYS } from './constants';

/** Token triple written to secure storage on login / refresh. */
export interface SessionTokens {
  accessToken: string;
  refreshToken: string;
  /** Unix timestamp (seconds) as returned by the API. */
  expiresTime: number;
}

export type SessionStatus = 'idle' | 'hydrating' | 'ready';

export interface SessionState {
  status: SessionStatus;
  accessToken: string | null;
  refreshToken: string | null;
  expiresTime: number | null;
  /** Logged-in === refresh token present (legacy parity with the Flutter apps). */
  isLoggedIn: boolean;
}

export interface SessionActions {
  /** Read tokens from secure storage into memory. Idempotent and single-flight. */
  hydrate: () => Promise<void>;
  setSession: (tokens: SessionTokens) => Promise<void>;
  clearSession: () => Promise<void>;
}

export type SessionStoreState = SessionState & SessionActions;
export type SessionStore = UseBoundStore<StoreApi<SessionStoreState>>;

/** Minimal async key-value storage contract (expo-secure-store compatible). */
export interface KeyValueStorage {
  getItem: (key: string) => Promise<string | null>;
  setItem: (key: string, value: string) => Promise<void>;
  removeItem: (key: string) => Promise<void>;
}

/** Default storage adapter backed by `expo-secure-store`. */
export const secureStoreStorage: KeyValueStorage = {
  getItem: (key) => SecureStore.getItemAsync(key),
  setItem: (key, value) => SecureStore.setItemAsync(key, value),
  removeItem: (key) => SecureStore.deleteItemAsync(key),
};

export interface SessionStoreOptions {
  /** Override storage (tests, web). Defaults to expo-secure-store. */
  storage?: KeyValueStorage;
}

export function createSessionStore(options: SessionStoreOptions = {}): SessionStore {
  const storage = options.storage ?? secureStoreStorage;
  let hydratePromise: Promise<void> | null = null;

  return create<SessionStoreState>((set, get) => ({
    status: 'idle',
    accessToken: null,
    refreshToken: null,
    expiresTime: null,
    isLoggedIn: false,

    hydrate: () => {
      if (get().status === 'ready') {
        return Promise.resolve();
      }
      if (hydratePromise) {
        return hydratePromise;
      }
      set({ status: 'hydrating' });
      hydratePromise = (async () => {
        try {
          const [accessToken, refreshToken, expiresTime] = await Promise.all([
            storage.getItem(SESSION_STORAGE_KEYS.accessToken),
            storage.getItem(SESSION_STORAGE_KEYS.refreshToken),
            storage.getItem(SESSION_STORAGE_KEYS.expiresTime),
          ]);
          const parsedExpires = expiresTime !== null ? Number(expiresTime) : null;
          set({
            status: 'ready',
            accessToken: accessToken || null,
            refreshToken: refreshToken || null,
            expiresTime:
              parsedExpires !== null && Number.isFinite(parsedExpires) ? parsedExpires : null,
            isLoggedIn: !!refreshToken,
          });
        } catch {
          // A storage failure must not wedge the app on a splash screen:
          // treat it as "logged out" and become ready anyway.
          set({ status: 'ready', isLoggedIn: false });
        } finally {
          hydratePromise = null;
        }
      })();
      return hydratePromise;
    },

    setSession: async (tokens) => {
      await Promise.all([
        storage.setItem(SESSION_STORAGE_KEYS.accessToken, tokens.accessToken),
        storage.setItem(SESSION_STORAGE_KEYS.refreshToken, tokens.refreshToken),
        storage.setItem(SESSION_STORAGE_KEYS.expiresTime, String(tokens.expiresTime)),
      ]);
      set({
        status: 'ready',
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        expiresTime: tokens.expiresTime,
        isLoggedIn: true,
      });
    },

    clearSession: async () => {
      await Promise.all([
        storage.removeItem(SESSION_STORAGE_KEYS.accessToken),
        storage.removeItem(SESSION_STORAGE_KEYS.refreshToken),
        storage.removeItem(SESSION_STORAGE_KEYS.expiresTime),
      ]);
      set({ accessToken: null, refreshToken: null, expiresTime: null, isLoggedIn: false });
    },
  }));
}

/** Shared default store. Each app is its own process/install, so one singleton is fine. */
export const sessionStore: SessionStore = createSessionStore();

/** React hook binding for the shared store (`useSessionStore((s) => s.isLoggedIn)`). */
export const useSessionStore: SessionStore = sessionStore;

export const selectIsLoggedIn = (state: SessionStoreState): boolean => state.isLoggedIn;
export const selectSessionStatus = (state: SessionStoreState): SessionStatus => state.status;

export function useIsLoggedIn(): boolean {
  return useSessionStore(selectIsLoggedIn);
}

export function useSessionStatus(): SessionStatus {
  return useSessionStore(selectSessionStatus);
}
