import { create } from 'zustand';

import type { LandlordAckItem, LandlordDueItem } from '@neast/types';

/**
 * Cross-screen "extra" payloads (go_router `extra` parity). Callers set the
 * selected entity before pushing a detail route; the route reads it here.
 * Detail routes tolerate a null selection (process death) with an error state.
 */
interface SelectionState {
  dueItem: LandlordDueItem | null;
  ackItem: LandlordAckItem | null;
  setDueItem: (item: LandlordDueItem | null) => void;
  setAckItem: (item: LandlordAckItem | null) => void;
}

export const useSelectionStore = create<SelectionState>()((set) => ({
  dueItem: null,
  ackItem: null,
  setDueItem: (dueItem) => set({ dueItem }),
  setAckItem: (ackItem) => set({ ackItem }),
}));
