import { create } from 'zustand';

import type { CouponListItem, RentListItem, UserCouponItem } from '@neast/types';

import type { RentHistoryEntry } from '../lib/types';

/**
 * Cross-screen "extra" payloads (go_router `extra` parity). Callers set the
 * selected entity before pushing a detail route; the route reads it here.
 * Every consumer also tolerates a null selection (deep link / process death)
 * by refetching from the API where possible.
 */
interface SelectionState {
  rent: RentListItem | null;
  history: RentHistoryEntry | null;
  coupon: CouponListItem | UserCouponItem | null;
  setRent: (rent: RentListItem | null) => void;
  setHistory: (history: RentHistoryEntry | null) => void;
  setCoupon: (coupon: CouponListItem | UserCouponItem | null) => void;
}

export const useSelectionStore = create<SelectionState>()((set) => ({
  rent: null,
  history: null,
  coupon: null,
  setRent: (rent) => set({ rent }),
  setHistory: (history) => set({ history }),
  setCoupon: (coupon) => set({ coupon }),
}));
