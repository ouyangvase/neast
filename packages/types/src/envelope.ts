/**
 * NEAST API response envelope.
 *
 * Every Hyperf endpoint responds with HTTP 200 and a JSON body of
 * `{ code, message | msg, data }`. Business success is `code == 200`;
 * `code == 400` means "login expired" (auth middleware) and triggers the
 * token-refresh flow; anything else is a business error carrying a
 * human-readable message.
 */
export interface ApiEnvelope<T = unknown> {
  code: number;
  message?: string;
  msg?: string;
  data: T;
}

export type ApiErrorKind =
  | 'business' // server replied with a non-200 business code
  | 'http' // non-2xx HTTP status
  | 'network' // fetch/XHR failed before any response
  | 'timeout' // request exceeded its timeout budget
  | 'cancelled' // aborted via AbortSignal
  | 'invalid_response'; // body was not a valid envelope

export class ApiError extends Error {
  /** Business code from the envelope, HTTP status, or 0 for client-side failures. */
  readonly code: number;
  readonly kind: ApiErrorKind;
  /** Raw `data` payload from the envelope, when present. */
  readonly data: unknown;

  constructor(
    code: number,
    message: string,
    kind: ApiErrorKind = 'business',
    data?: unknown,
    options?: { cause?: unknown },
  ) {
    super(message);
    this.name = 'ApiError';
    this.code = code;
    this.kind = kind;
    this.data = data;
    if (options?.cause !== undefined) {
      this.cause = options.cause;
    }
  }
}

export function isApiError(error: unknown): error is ApiError {
  return error instanceof ApiError;
}

/** Message lives in `message`, falling back to `msg` (both appear in the wild). */
export function extractEnvelopeMessage(envelope: { message?: unknown; msg?: unknown }): string {
  const message = envelope.message;
  if (typeof message === 'string' && message !== '') {
    return message;
  }
  const msg = envelope.msg;
  if (typeof msg === 'string' && msg !== '') {
    return msg;
  }
  return '';
}

/**
 * Parse a raw response body into an envelope. Returns `null` when the body is
 * not JSON, not an object, or lacks a numeric `code` ("invalid response format").
 */
export function tryParseEnvelope(body: string): ApiEnvelope | null {
  let parsed: unknown;
  try {
    parsed = JSON.parse(body);
  } catch {
    return null;
  }
  if (typeof parsed !== 'object' || parsed === null) {
    return null;
  }
  const code = (parsed as { code?: unknown }).code;
  if (typeof code !== 'number' || Number.isNaN(code)) {
    return null;
  }
  return parsed as ApiEnvelope;
}
