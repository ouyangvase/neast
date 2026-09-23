import { create } from 'zustand';

/**
 * Pending deep-link stash (pending_route_provider parity). A merchant deep
 * link that arrives while logged out is stashed here and replayed after auth.
 */
interface PendingRouteState {
  pending: string | null;
  stash: (route: string) => void;
  /** Read and clear. */
  drain: () => string | null;
}

export const usePendingRouteStore = create<PendingRouteState>()((set, get) => ({
  pending: null,
  stash: (route) => set({ pending: route }),
  drain: () => {
    const pending = get().pending;
    if (pending) {
      set({ pending: null });
    }
    return pending;
  },
}));

export function stashPendingRoute(route: string): void {
  usePendingRouteStore.getState().stash(route);
}

export function drainPendingRoute(): string | null {
  return usePendingRouteStore.getState().drain();
}

export function peekPendingRoute(): string | null {
  return usePendingRouteStore.getState().pending;
}
