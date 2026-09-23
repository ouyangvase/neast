import { create } from 'zustand';

/** MainScreen tabs (IndexedStack parity — tabs are app state, not routes). */
export type MainTab = 'scan' | 'givePoints' | 'settlement' | 'account';

interface TabsState {
  tab: MainTab;
  select: (tab: MainTab) => void;
  /** Back to Scan (post-login / logout reset) — the merchant default tab. */
  reset: () => void;
}

export const useTabsStore = create<TabsState>()((set) => ({
  tab: 'scan',
  select: (tab) => set({ tab }),
  reset: () => set({ tab: 'scan' }),
}));
