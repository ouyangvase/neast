import {
  DEFAULT_API_BASE_URL,
  GET_REQUEST_DELAY_MS,
  REQUEST_TIMEOUT_MS,
  UPLOAD_TIMEOUT_MS,
} from './constants';
import { ApiError, extractEnvelopeMessage, tryParseEnvelope } from './envelope';
import { sessionStore, type SessionStore } from './session';
import type { RefreshTokenResponse, UploadFileResult } from './contracts/common';
import { uploadFile, type UploadFileInput, type UploadOptions } from './upload';

/** API audience prefix — one per app. */
export type ApiPrefix = '/app' | '/landlord' | '/merchant';

export type LogoutReason =
  | 'refresh_failed' // refresh-token call failed or was rejected
  | 'session_expired' // a retried request got a second business 400
  | 'unauthorized'; // HTTP 401 while logged in

export interface ApiClientOptions {
  prefix: ApiPrefix;
  /** Defaults to `process.env.EXPO_PUBLIC_API_URL`, then `http://10.0.2.2:9512`. */
  baseUrl?: string;
  /** Defaults to the shared `sessionStore` singleton. */
  session?: SessionStore;
  /** Called after the session was cleared due to an unrecoverable auth failure. */
  onLogout?: (reason: LogoutReason) => void;
  /** Test hook. Defaults to the global `fetch`. */
  fetchFn?: typeof fetch;
  /** Legacy parity: artificial delay before every GET (default 200ms). Set 0 to disable. */
  getDelayMs?: number;
  /** Default per-request timeout for JSON calls (default 15000ms). */
  timeoutMs?: number;
}

export type QueryParams = Record<string, string | number | boolean | null | undefined>;

export interface RequestOptions {
  signal?: AbortSignal;
  timeoutMs?: number;
}

export interface MultipartRequestOptions extends RequestOptions {
  /** Extra string/number form fields (numbers are stringified). */
  fields?: Record<string, string | number>;
  /** Form field name for the file part (always `file` on this backend). */
  fileField: string;
  /** Blob (chunk) or an RN file descriptor (`{ uri, name, type }`). */
  file: Blob | UploadFileInput;
  filename: string;
  onProgress?: (loadedBytes: number, totalBytes: number) => void;
}

export interface ApiClient {
  readonly prefix: ApiPrefix;
  readonly baseUrl: string;
  readonly session: SessionStore;
  get<T>(path: string, query?: QueryParams, options?: RequestOptions): Promise<T>;
  post<T>(path: string, body?: unknown, options?: RequestOptions): Promise<T>;
  put<T>(path: string, body?: unknown, options?: RequestOptions): Promise<T>;
  delete<T>(path: string, options?: RequestOptions): Promise<T>;
  request<T>(
    method: HttpMethod,
    path: string,
    options?: RequestOptions & { query?: QueryParams; body?: unknown },
  ): Promise<T>;
  /** Multipart POST with upload progress, envelope handling and 400-refresh retry. */
  uploadMultipart<T>(path: string, options: MultipartRequestOptions): Promise<T>;
  /** Chunked upload helper (see upload.ts). */
  uploadFile(file: UploadFileInput, options?: UploadOptions): Promise<UploadFileResult>;
  /** Single-flight token refresh. Resolves false when the session was cleared. */
  refreshSession(): Promise<boolean>;
}

export type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';

/** Minimal XMLHttpRequest surface (RN provides the global; we avoid DOM-lib types). */
interface MinimalXhr {
  open: (method: string, url: string) => void;
  setRequestHeader: (name: string, value: string) => void;
  send: (body?: unknown) => void;
  abort: () => void;
  timeout: number;
  status: number;
  responseText: string;
  upload?: { onprogress: ((event: { loaded: number; total: number }) => void) | null };
  onload: (() => void) | null;
  onerror: (() => void) | null;
  ontimeout: (() => void) | null;
  onabort: (() => void) | null;
}

function createXhr(): MinimalXhr {
  const ctor = (globalThis as { XMLHttpRequest?: new () => MinimalXhr }).XMLHttpRequest;
  if (!ctor) {
    throw new ApiError(0, 'XMLHttpRequest is not available', 'network');
  }
  return new ctor();
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function isBlob(value: unknown): value is Blob {
  return typeof Blob !== 'undefined' && value instanceof Blob;
}

function appendFilePart(
  form: FormData,
  field: string,
  file: Blob | UploadFileInput,
  filename: string,
): void {
  if (isBlob(file)) {
    form.append(field, file, filename);
    return;
  }
  // React Native file descriptor (ImagePicker / DocumentPicker style).
  const descriptor = {
    uri: file.uri,
    name: file.name || filename,
    type: file.type || 'application/octet-stream',
  };
  form.append(field, descriptor as unknown as Blob, descriptor.name);
}

interface ComposedSignal {
  signal: AbortSignal;
  isTimeout: () => boolean;
  dispose: () => void;
}

/** Combine a caller AbortSignal with a timeout into one fetch signal. */
function composeAbortSignal(signal: AbortSignal | undefined, timeoutMs: number): ComposedSignal {
  const controller = new AbortController();
  let timedOut = false;
  const timer = setTimeout(() => {
    timedOut = true;
    controller.abort();
  }, timeoutMs);
  const onAbort = () => controller.abort();
  if (signal) {
    if (signal.aborted) {
      controller.abort();
    } else {
      signal.addEventListener('abort', onAbort, { once: true });
    }
  }
  return {
    signal: controller.signal,
    isTimeout: () => timedOut,
    dispose: () => {
      clearTimeout(timer);
      if (signal) {
        signal.removeEventListener('abort', onAbort);
      }
    },
  };
}

function mapTransportError(
  error: unknown,
  userSignal: AbortSignal | undefined,
  isTimeout: () => boolean,
): ApiError {
  if (isTimeout()) {
    return new ApiError(0, 'Connection timeout, please try again', 'timeout', undefined, {
      cause: error,
    });
  }
  if (userSignal?.aborted || (error instanceof Error && error.name === 'AbortError')) {
    return new ApiError(0, 'Request cancelled', 'cancelled', undefined, { cause: error });
  }
  return new ApiError(0, 'Network connection failed, please try again', 'network', undefined, {
    cause: error,
  });
}

class ApiClientImpl implements ApiClient {
  readonly prefix: ApiPrefix;
  readonly baseUrl: string;
  readonly session: SessionStore;

  private readonly onLogout?: (reason: LogoutReason) => void;
  private readonly fetchFn: typeof fetch;
  private readonly getDelayMs: number;
  private readonly timeoutMs: number;
  private refreshPromise: Promise<boolean> | null = null;

  constructor(options: ApiClientOptions) {
    this.prefix = options.prefix;
    const rawBaseUrl = options.baseUrl ?? process.env.EXPO_PUBLIC_API_URL ?? DEFAULT_API_BASE_URL;
    this.baseUrl = rawBaseUrl.replace(/\/+$/, '');
    this.session = options.session ?? sessionStore;
    this.onLogout = options.onLogout;
    this.fetchFn = options.fetchFn ?? ((input, init) => fetch(input, init));
    this.getDelayMs = options.getDelayMs ?? GET_REQUEST_DELAY_MS;
    this.timeoutMs = options.timeoutMs ?? REQUEST_TIMEOUT_MS;
  }

  get<T>(path: string, query?: QueryParams, options?: RequestOptions): Promise<T> {
    return this.request<T>('GET', path, { ...options, query });
  }

  post<T>(path: string, body?: unknown, options?: RequestOptions): Promise<T> {
    return this.request<T>('POST', path, { ...options, body });
  }

  put<T>(path: string, body?: unknown, options?: RequestOptions): Promise<T> {
    return this.request<T>('PUT', path, { ...options, body });
  }

  delete<T>(path: string, options?: RequestOptions): Promise<T> {
    return this.request<T>('DELETE', path, options);
  }

  request<T>(
    method: HttpMethod,
    path: string,
    options?: RequestOptions & { query?: QueryParams; body?: unknown },
  ): Promise<T> {
    return this.withAuthRetry(() => this.executeJson<T>(method, path, options));
  }

  uploadMultipart<T>(path: string, options: MultipartRequestOptions): Promise<T> {
    return this.withAuthRetry(() => this.executeUpload<T>(path, options));
  }

  uploadFile(file: UploadFileInput, options?: UploadOptions): Promise<UploadFileResult> {
    return uploadFile(this, file, options);
  }

  /**
   * Refresh the access token. Concurrent callers share one in-flight request
   * (single-flight); the original request is retried once by withAuthRetry.
   */
  refreshSession(): Promise<boolean> {
    this.refreshPromise ??= this.performRefresh().finally(() => {
      this.refreshPromise = null;
    });
    return this.refreshPromise;
  }

  /** Refresh token travels as a QUERY param on a bare POST (no auth header). */
  private async performRefresh(): Promise<boolean> {
    const refreshToken = this.session.getState().refreshToken;
    if (!refreshToken) {
      return false;
    }
    try {
      const url = `${this.baseUrl}${this.prefix}/auth/refresh-token?refreshToken=${encodeURIComponent(refreshToken)}`;
      const response = await this.fetchFn(url, {
        method: 'POST',
        headers: { Accept: 'application/json' },
      });
      const envelope = tryParseEnvelope(await response.text());
      if (!response.ok || !envelope || envelope.code !== 200) {
        throw new Error('Refresh token rejected');
      }
      const data = envelope.data as RefreshTokenResponse;
      await this.session.getState().setSession({
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
        expiresTime: data.expiresTime,
      });
      return true;
    } catch {
      await this.logout('refresh_failed');
      return false;
    }
  }

  /** Clear the session and notify the app. Guests do not emit logout. */
  private async logout(reason: LogoutReason): Promise<void> {
    const wasLoggedIn = this.session.getState().isLoggedIn;
    await this.session.getState().clearSession();
    if (wasLoggedIn) {
      this.onLogout?.(reason);
    }
  }

  /**
   * Business `code == 400` means "login expired": refresh once (single-flight),
   * retry the original request once, and log out when that still fails.
   */
  private async withAuthRetry<T>(execute: () => Promise<T>, retried = false): Promise<T> {
    try {
      return await execute();
    } catch (error) {
      const isBusiness400 =
        error instanceof ApiError && error.kind === 'business' && error.code === 400;
      if (!isBusiness400) {
        throw error;
      }
      if (!retried) {
        const refreshed = await this.refreshSession();
        if (refreshed) {
          return this.withAuthRetry(execute, true);
        }
        throw error; // refresh failed — logout already emitted
      }
      await this.logout('session_expired');
      throw error;
    }
  }

  private buildUrl(path: string, query?: QueryParams): string {
    const normalizedPath = path.startsWith('/') ? path : `/${path}`;
    let url = `${this.baseUrl}${this.prefix}${normalizedPath}`;
    if (query) {
      const search = new URLSearchParams();
      for (const [key, value] of Object.entries(query)) {
        if (value === null || value === undefined) {
          continue;
        }
        search.append(key, String(value));
      }
      const qs = search.toString();
      if (qs !== '') {
        url += `?${qs}`;
      }
    }
    return url;
  }

  private async executeJson<T>(
    method: HttpMethod,
    path: string,
    options?: RequestOptions & { query?: QueryParams; body?: unknown },
  ): Promise<T> {
    // Legacy parity: the Flutter dio clients delay every GET by 200ms.
    if (method === 'GET' && this.getDelayMs > 0) {
      await sleep(this.getDelayMs);
    }
    const url = this.buildUrl(path, options?.query);
    const headers: Record<string, string> = { Accept: 'application/json' };
    // Raw token, NO `Bearer ` prefix — the backend middleware expects this.
    const token = this.session.getState().accessToken;
    if (token) {
      headers.Authorization = token;
    }
    let body: string | undefined;
    if (options?.body !== undefined) {
      headers['Content-Type'] = 'application/json';
      body = JSON.stringify(options.body);
    }
    const composed = composeAbortSignal(options?.signal, options?.timeoutMs ?? this.timeoutMs);
    let response: Response;
    try {
      response = await this.fetchFn(url, { method, headers, body, signal: composed.signal });
    } catch (error) {
      throw mapTransportError(error, options?.signal, composed.isTimeout);
    } finally {
      composed.dispose();
    }
    const envelope = tryParseEnvelope(await response.text());
    if (!response.ok) {
      if (response.status === 401 && this.session.getState().isLoggedIn) {
        await this.logout('unauthorized');
      }
      const message = envelope ? extractEnvelopeMessage(envelope) : '';
      throw new ApiError(response.status, message || `HTTP ${response.status}`, 'http');
    }
    if (!envelope) {
      throw new ApiError(0, 'Invalid response format', 'invalid_response');
    }
    if (envelope.code === 200) {
      return envelope.data as T;
    }
    throw new ApiError(envelope.code, extractEnvelopeMessage(envelope), 'business', envelope.data);
  }

  private executeUpload<T>(path: string, options: MultipartRequestOptions): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      const xhr = createXhr();
      xhr.open('POST', this.buildUrl(path));
      xhr.timeout = options.timeoutMs ?? UPLOAD_TIMEOUT_MS;
      const token = this.session.getState().accessToken;
      if (token) {
        xhr.setRequestHeader('Authorization', token);
      }
      xhr.setRequestHeader('Accept', 'application/json');

      const form = new FormData();
      for (const [key, value] of Object.entries(options.fields ?? {})) {
        form.append(key, String(value));
      }
      appendFilePart(form, options.fileField, options.file, options.filename);

      const signal = options.signal;
      const onAbort = () => xhr.abort();
      if (signal) {
        if (signal.aborted) {
          reject(new ApiError(0, 'Request cancelled', 'cancelled'));
          return;
        }
        signal.addEventListener('abort', onAbort, { once: true });
      }
      const cleanup = () => {
        if (signal) {
          signal.removeEventListener('abort', onAbort);
        }
      };

      if (xhr.upload) {
        xhr.upload.onprogress = (event) => {
          options.onProgress?.(event.loaded, event.total);
        };
      }
      xhr.onload = () => {
        cleanup();
        const envelope = tryParseEnvelope(xhr.responseText);
        if (xhr.status >= 200 && xhr.status < 300) {
          if (!envelope) {
            reject(new ApiError(0, 'Invalid response format', 'invalid_response'));
            return;
          }
          if (envelope.code === 200) {
            resolve(envelope.data as T);
            return;
          }
          reject(
            new ApiError(
              envelope.code,
              extractEnvelopeMessage(envelope),
              'business',
              envelope.data,
            ),
          );
          return;
        }
        if (xhr.status === 401 && this.session.getState().isLoggedIn) {
          void this.logout('unauthorized');
        }
        const message = envelope ? extractEnvelopeMessage(envelope) : '';
        reject(new ApiError(xhr.status, message || `HTTP ${xhr.status}`, 'http'));
      };
      xhr.onerror = () => {
        cleanup();
        reject(new ApiError(0, 'Network connection failed, please try again', 'network'));
      };
      xhr.ontimeout = () => {
        cleanup();
        reject(new ApiError(0, 'Connection timeout, please try again', 'timeout'));
      };
      xhr.onabort = () => {
        cleanup();
        reject(new ApiError(0, 'Request cancelled', 'cancelled'));
      };
      xhr.send(form);
    });
  }
}

/**
 * Create a per-app API client.
 *
 * ```ts
 * const api = createApiClient({ prefix: '/app' });
 * const profile = await api.get<UserProfile>('user/profile');
 * ```
 */
export function createApiClient(options: ApiClientOptions): ApiClient {
  return new ApiClientImpl(options);
}
