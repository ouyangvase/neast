/**
 * Fiuu H5 payment-result detection.
 *
 * Success detection is purely URL-based (no polling endpoint): the WebView
 * watches navigation URLs, classifies by substring, waits a 2.5s grace period
 * so the result page can render, then shows a short "Processing…" state
 * (0.5s, or 10s for pending) before the screen pops the integer result.
 * A user-initiated back pops `null` (cancelled) — that stays in app code.
 */

/** Result codes popped by the H5 WebView screen (legacy parity). */
export const FIUU_RESULT_CODES = {
  success: 0,
  pending: 1,
  failed: 2,
} as const;
export type FiuuResultCode = (typeof FIUU_RESULT_CODES)[keyof typeof FIUU_RESULT_CODES];

/** Classify a navigation URL. Returns `null` for non-result URLs. */
export function classifyFiuuResultUrl(url: string): FiuuResultCode | null {
  if (url.includes('/pay_success.html')) {
    return FIUU_RESULT_CODES.success;
  }
  if (url.includes('pay_pending')) {
    return FIUU_RESULT_CODES.pending;
  }
  if (url.includes('pay_failed')) {
    return FIUU_RESULT_CODES.failed;
  }
  return null;
}

export type FiuuTrackerPhase = 'idle' | 'grace' | 'processing' | 'done';

export interface FiuuResultTrackerOptions {
  /** Grace period after a result URL is detected (default 2500ms). */
  graceMs?: number;
  /** "Processing…" duration for success/failed (default 500ms). */
  processingMs?: number;
  /** "Processing…" duration for pending (default 10000ms). */
  pendingProcessingMs?: number;
  onPhaseChange?: (phase: FiuuTrackerPhase, result: FiuuResultCode | null) => void;
  /** Fired once, after grace + processing, with the final result code. */
  onResult?: (result: FiuuResultCode) => void;
}

export interface FiuuResultTracker {
  /** Feed every WebView navigation URL here (onPageStarted / onNavigationRequest). */
  handleUrl: (url: string) => void;
  /** Stop timers without emitting a result (user backed out → pop null). */
  cancel: () => void;
  readonly phase: FiuuTrackerPhase;
  readonly result: FiuuResultCode | null;
}

/**
 * Small state machine replicating the Flutter WebView timing:
 * `idle → grace (2.5s) → processing (0.5s / 10s pending) → done (emit result)`.
 * The first recognized result URL wins; later navigations are ignored.
 */
export function createFiuuResultTracker(options: FiuuResultTrackerOptions = {}): FiuuResultTracker {
  const graceMs = options.graceMs ?? 2500;
  const processingMs = options.processingMs ?? 500;
  const pendingProcessingMs = options.pendingProcessingMs ?? 10_000;

  let phase: FiuuTrackerPhase = 'idle';
  let result: FiuuResultCode | null = null;
  let timer: ReturnType<typeof setTimeout> | null = null;

  const setPhase = (next: FiuuTrackerPhase) => {
    phase = next;
    options.onPhaseChange?.(next, result);
  };
  const clearTimer = () => {
    if (timer !== null) {
      clearTimeout(timer);
      timer = null;
    }
  };

  return {
    handleUrl(url: string) {
      if (phase !== 'idle') {
        return;
      }
      const classified = classifyFiuuResultUrl(url);
      if (classified === null) {
        return;
      }
      result = classified;
      setPhase('grace');
      timer = setTimeout(() => {
        setPhase('processing');
        const wait = result === FIUU_RESULT_CODES.pending ? pendingProcessingMs : processingMs;
        timer = setTimeout(() => {
          setPhase('done');
          if (result !== null) {
            options.onResult?.(result);
          }
        }, wait);
      }, graceMs);
    },
    cancel() {
      clearTimer();
      if (phase !== 'done') {
        result = null;
        setPhase('idle');
      }
    },
    get phase() {
      return phase;
    },
    get result() {
      return result;
    },
  };
}
